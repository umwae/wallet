import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/core/utils/extensions/string_extension.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/core/widget/bottom_sheet_mixin.dart';
import 'package:stonwallet/src/feature/transactions/cubit/transactions_cubit.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';

class TransactionsView extends BasePage {
  final List<String> filters = ['Отправлено', 'Получено', 'Все'];

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
            BlocBuilder<TransactionsCubit, TransactionsState>(
              builder: (context, state) {
                final grouped = _groupByMonth(state.filteredTransactions);
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
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              for (final filter in filters)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: state.selectedFilter == filter,
                    onSelected: (selected) {
                      context.read<TransactionsCubit>().setFilter(selected ? filter : null);
                    },
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: state.selectedFilter == filter
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
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
      },
    );
  }

  Widget _buildTransactionTile(TransactionEntity tx, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final amountColor = _getTransactionColor(tx, context);

    return GestureDetector(
      onTap: () => openBottomSheet(
        context,
        itemBuilder: (context) => _buildTransactionDetails(tx, context),
      ),
      child: Card(
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
                    tx.counterparty.shortForm(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(TransactionEntity tx, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final amountColor = _getTransactionColor(tx, context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Card(
          color: colorScheme.surfaceVariant,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SvgPicture.asset(tx.coinImage, height: 50),
            ),
          ),
        ),
        const SizedBox(height: 48),
        _buildDetailRow('Сумма', tx.amount, theme, colorScheme, valueColor: amountColor),
        _buildDetailRow('Дата', tx.date, theme, colorScheme),
        _buildDetailRow('Адрес', tx.counterparty, theme, colorScheme),
        if (tx.message != null && tx.message!.isNotEmpty)
          _buildDetailRow('Сообщение', tx.message!, theme, colorScheme),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    ThemeData theme,
    ColorScheme colorScheme, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: valueColor ?? colorScheme.onSurface,
              ),
            ),
          ),
        ],
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

