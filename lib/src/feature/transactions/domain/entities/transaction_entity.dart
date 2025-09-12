import 'package:flutter/material.dart' show IconData;

class TransactionEntity {
  final TransactionType type; // 'sent', 'received', 'contract', etc.
  final String typeLocalized;
  final String counterparty;
  final String amount;
  final String date;
  final IconData icon;
  final String coinImage;
  final String? message;
  final String monthYear;

  TransactionEntity({
    required this.type,
    required this.typeLocalized,
    required this.counterparty,
    required this.amount,
    required this.date,
    required this.icon,
    required this.coinImage,
    required this.monthYear,
    this.message,
  });
}

enum TransactionType { incoming, outgoing, contractCall, init }
