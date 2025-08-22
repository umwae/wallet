import 'dart:math' show pow;

import 'package:intl/intl.dart';

extension FloorFormatter on double {
  String floorFormat({
    NumberFormat? numberFormat,
    String? locale = 'ru_RU',
    String? name,
    String? symbol,
    int? decimalDigits,
    String? customPattern,
  }) {
    final formatter = numberFormat ??
        NumberFormat.currency(
          locale: locale,
          name: name,
          symbol: symbol,
          decimalDigits: decimalDigits,
          customPattern: customPattern,
        );
    final factor = pow(10, decimalDigits ?? 2);
    final floored = (this * factor).floor() / factor;
    return formatter.format(floored);
  }

  String formatted({String locale = 'ru_RU'}) {
    return NumberFormat.currency(locale: locale, symbol: '₽', decimalDigits: 2).format(this);
  }

  String compact({String locale = 'ru_RU'}) {
    return NumberFormat.compact(locale: locale).format(this);
  }

  String compactFormatted({String locale = 'ru_RU'}) {
    return NumberFormat.compactCurrency(locale: locale, symbol: '₽', decimalDigits: 2).format(this);
  }
}
