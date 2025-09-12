import 'package:flutter/material.dart';
import 'package:stonwallet/src/core/constant/svg.dart';
import 'package:stonwallet/src/core/utils/extensions/double_extension.dart';
import 'package:stonwallet/src/core/utils/extensions/message_extension.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:tonutils/tonutils.dart' show CmiInternal, Transaction;

List<TransactionEntity> mapRawTransaction(Transaction tx, String accountAddress) {
  final events = <TransactionEntity>[];
  final incoming = _parseIncoming(tx, accountAddress);
  if (incoming != null) events.add(incoming);
  events.addAll(_parseOutgoings(tx, accountAddress));
  return events;
}

TransactionEntity? _parseIncoming(Transaction tx, String accountAddress) {
  final msg = tx.inMessage;
  if (msg == null) return null;

  if (msg.info is! CmiInternal) return null;
  final info = msg.info as CmiInternal;

  final destStr = info.dest.toString();
  if (destStr != accountAddress) return null;

  final value = info.value.coins; // BigInt in nanoTON
  final tons = value.toDouble() / 1e9;

  return TransactionEntity(
    type: TransactionType.incoming,
    typeLocalized: 'Получено',
    amount: tons.cryptoSignedFormatted(symbol: 'TON'),
    date: _formatDateVerbose(tx.now),
    monthYear: _monthYear(tx.now),
    counterparty: info.src.toString(),
    message: msg.comment,
    icon: Icons.arrow_circle_down,
    coinImage: PathsSvg.tonLogoDark,
  );
}

List<TransactionEntity> _parseOutgoings(Transaction tx, String accountAddress) {
  final events = <TransactionEntity>[];
  for (final m in tx.outMessages.values) {
    if (m.info is! CmiInternal) {
      continue;
    }
    final info = m.info as CmiInternal;
    final srcStr = info.src.toString();
    if (srcStr != accountAddress) continue;

    final value = info.value.coins; // BigInt in nanoTON
    final tons = -value.toDouble() / 1e9;

    events.add(
      TransactionEntity(
        type: TransactionType.outgoing,
        typeLocalized: 'Отправлено',
        amount: tons.cryptoSignedFormatted(symbol: 'TON'),
        date: _formatDateVerbose(tx.now),
        monthYear: _monthYear(tx.now),
        counterparty: info.dest.toString(),
        message: null,
        icon: Icons.arrow_circle_up,
        coinImage: PathsSvg.tonLogoDark,
      ),
    );
  }
  return events;
}

String _formatDateVerbose(int unix) {
  final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
  final day = dt.day.toString().padLeft(2, '0');
  final month = _monthFullRuGenitive(dt.month);
  final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  return '$day $month в $time';
}

String _monthYear(int unix) {
  final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
  final currentYear = DateTime.now().year;
  if (dt.year == currentYear) {
    return _monthFullRu(dt.month);
  }
  return '${_monthFullRu(dt.month)} ${dt.year}';
}

String _monthShortRu(int month) {
  const months = [
    'янв.',
    'февр.',
    'мар.',
    'апр.',
    'мая',
    'июн.',
    'июл.',
    'авг.',
    'сент.',
    'окт.',
    'нояб.',
    'дек.',
  ];
  return months[month - 1];
}

String _monthFullRu(int month) {
  const months = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];
  return months[month - 1];
}

String _monthFullRuGenitive(int month) {
  const months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];
  return months[month - 1];
}
