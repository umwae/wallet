import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/core/utils/extensions/string_extension.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/transactions/cubit/transactions_cubit.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:stonwallet/src/core/widget/bold_card.dart';

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
    final extraColors = Theme.of(context).extension<ExtraColors>()!;
    return Scaffold(
      backgroundColor: extraColors.bgGradientEnd,
      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              delegate: _SliverTitleDelegate(
                minHeight: 0,
                maxHeight: 48,
                child: Center(
                  child: Text(
                    'История транзакций',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
            SliverAppBar(
              backgroundColor: extraColors.bgGradientEnd,
              surfaceTintColor: Colors.transparent,
              pinned: true,
              toolbarHeight: 0,
              automaticallyImplyLeading: false,
              //Фильтры
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: _buildFilters(context),
              ),
            ),
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

    return BoldCard(
      onTap: () => openBottomSheet(
        context,
        itemBuilder: (context) => _buildTransactionDetails(tx, context),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(tx.icon, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          tx.typeLocalized,
          style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tx.date,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
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
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tx.amount,
              style: theme.textTheme.titleMedium?.copyWith(
                color: amountColor,
              ),
            ),
            Text(
              tx.counterparty.shortForm(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(TransactionEntity tx, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final amountColor = _getTransactionColor(tx, context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              // width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.02)),
              ),
              child: SvgPicture.asset(tx.coinImage, height: 50),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  tx.amount,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tx.counterparty.shortForm(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tx.date,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (tx.message != null && tx.message!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Center(
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
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.02)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Сумма', tx.amount, theme, colorScheme, valueColor: amountColor),
                  const Divider(height: 20),
                  _buildDetailRow('Дата', tx.date, theme, colorScheme),
                  const Divider(height: 20),
                  _buildDetailRow('Адрес', tx.counterparty, theme, colorScheme),
                  if (tx.message != null && tx.message!.isNotEmpty) ...[
                    const Divider(height: 20),
                    _buildDetailRow('Сообщение', tx.message!, theme, colorScheme),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
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

class _SliverTitleDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverTitleDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _SliverTitleDelegate oldDelegate) =>
      oldDelegate.maxHeight != maxHeight || oldDelegate.child != child;
}
