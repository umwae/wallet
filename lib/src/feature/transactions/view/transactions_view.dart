import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/transactions/cubit/transactions_cubit.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';

class TransactionsView extends BasePage {
  final List<String> filters = ['Отправлено', 'Получено', 'Спам'];

  @override
  Future<void> onRefresh(BuildContext context) async {
    final deps = DependenciesScope.of(context);
    await context.read<TransactionsCubit>().fetchTransactions(deps.openedWallet.address);
  }

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colorScheme.surface,
              pinned: true,
              title: Text(
                'История транзакций',
                style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(child: _buildFilters(context)),
            BlocBuilder<TransactionsCubit, List<TransactionEntity>>(
              builder: (context, transactions) {
                final grouped = _groupByMonth(transactions);
                final sectionWidgets = <Widget>[];
                for (final entry in grouped.entries) {
                  sectionWidgets.add(
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Text(
                        entry.key,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                  sectionWidgets.addAll(
                    entry.value.map((tx) => _buildTransactionTile(tx, context)).toList(),
                  );
                }
                return SliverList(
                  delegate: SliverChildListDelegate(sectionWidgets),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          for (final label in filters)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: false,
                onSelected: (_) {},
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                backgroundColor: colorScheme.surfaceVariant,
                selectedColor: colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(TransactionEntity tx, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final amountColor = _getTransactionColor(tx, context);
    return Card(
      color: colorScheme.surfaceVariant,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(tx.icon, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.typeLocalized,
                    style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tx.date,
                    style:
                        theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  if (tx.message != null && tx.message!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tx.message!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tx.amount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _shortAddress(tx.counterparty),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<TransactionEntity>> _groupByMonth(List<TransactionEntity> txs) {
    final grouped = <String, List<TransactionEntity>>{};
    for (final tx in txs) {
      grouped.putIfAbsent(tx.monthYear, () => []).add(tx);
    }
    return grouped;
  }
}

Color _getTransactionColor(TransactionEntity tx, BuildContext context) {
  final extraColors = Theme.of(context).extension<ExtraColors>()!;
  final color = switch (tx.type) {
    TransactionType.incoming => extraColors.contentColorGreen,
    TransactionType.outgoing => extraColors.contentColorRed,
    _ => Theme.of(context).colorScheme.onSurfaceVariant,
  };
  return color;
}

String _shortAddress(String address) {
  if (address.length <= 8) return address;
  return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
}
