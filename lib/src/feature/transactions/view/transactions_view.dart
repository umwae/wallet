import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction {
  final String type; // 'sent', 'received', 'contract', etc.
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final IconData icon;
  final Color color;
  final String? comment;
  final String monthYear;

  Transaction({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
    this.comment,
    required this.monthYear,
  });
}

class TransactionsView extends StatelessWidget {
  final List<String> filters = ['Отправлено', 'Получено', 'Спам'];

  final List<Transaction> transactions = [
    Transaction(
      type: 'contract',
      title: 'Вызов контракта',
      subtitle: 'UQCZ...SudU',
      amount: '-0,42 TON',
      date: '26 авг, 12:35',
      icon: Icons.settings,
      color: Colors.grey,
      monthYear: 'Август 2024',
    ),
    Transaction(
      type: 'received',
      title: 'Получено',
      subtitle: 'EQBN...u8D-',
      amount: '+29 084 DOGS',
      date: '26 авг, 12:35',
      icon: Icons.download,
      color: Colors.green,
      monthYear: 'Август 2024',
    ),
    Transaction(
      type: 'received',
      title: 'Получено',
      subtitle: 'Wallet in Telegram',
      amount: '+0,5 TON',
      date: '26 авг, 12:21',
      icon: Icons.account_balance_wallet,
      color: Colors.green,
      monthYear: 'Август 2024',
    ),
    Transaction(
      type: 'sent',
      title: 'Отправлено',
      subtitle: 'UQCm...R1WL',
      amount: '-0,1 TON',
      date: '14 авг, 14:35',
      icon: Icons.upload,
      color: Colors.red,
      monthYear: 'Август 2024',
    ),
    Transaction(
      type: 'init',
      title: 'Кошелёк инициализи',
      subtitle: 'UQCZ...SudU',
      amount: '',
      date: '14 авг, 14:35',
      icon: Icons.check_circle,
      color: Colors.grey,
      monthYear: 'Август 2024',
    ),
    Transaction(
      type: 'received',
      title: 'Получено',
      subtitle: 'Wallet in Telegram',
      amount: '+0,1 TON',
      date: '14 авг, 14:28',
      icon: Icons.account_balance_wallet,
      color: Colors.green,
      monthYear: 'Август 2024',
    ),
    Transaction(
      type: 'received',
      title: 'Получено',
      subtitle: 'EQCK...CZwT',
      amount: '+0,047 TON',
      date: '19 июнь, 20:49',
      icon: Icons.download,
      color: Colors.green,
      comment: 'from kakaxa with love',
      monthYear: 'Июнь 2024',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMonth(transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('История'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView(
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
                    ...entry.value.map((tx) => _buildTransactionTile(tx)),
                  ],
                );
              }).toList(),
            ),
          )
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
            .map((label) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction tx) {
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
          Icon(tx.icon, color: tx.color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  tx.subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.white60),
                ),
                if (tx.comment != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      tx.comment!,
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
                    color: tx.amount.startsWith('+')
                        ? Colors.green
                        : tx.amount.startsWith('-')
                            ? Colors.red
                            : Colors.white,
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

  Map<String, List<Transaction>> _groupByMonth(List<Transaction> txs) {
    final Map<String, List<Transaction>> grouped = {};
    for (var tx in txs) {
      grouped.putIfAbsent(tx.monthYear, () => []).add(tx);
    }
    return grouped;
  }
}
