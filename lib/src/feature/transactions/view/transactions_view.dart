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
    return Scaffold(
      appBar: AppBar(
        title: const Text('История транзакций'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocBuilder<TransactionsCubit, List<TransactionEntity>>(
              builder: (context, transactions) {
                final grouped = _groupByMonth(transactions);
                return ListView(
                  padding: const EdgeInsets.all(12),
                  children: grouped.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...entry.value.map((tx) => _buildTransactionTile(tx, context)),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: filters
            .map(
              (label) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTransactionTile(TransactionEntity tx, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(tx.icon, color: _getTransactionColor(tx, context), size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.typeLocalized,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  tx.date,
                  style: const TextStyle(fontSize: 13, color: Colors.white60),
                ),
                if (tx.message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      tx.message!,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (tx.amount.isNotEmpty)
                Text(
                  tx.amount,
                  style: TextStyle(
                    color: _getTransactionColor(tx, context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                tx.date,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
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
