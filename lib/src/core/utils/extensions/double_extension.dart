import 'dart:math' show pow;

import 'package:intl/intl.dart';

extension DoubleFormatter on double {
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

// + 1.2345 TON
  String cryptoSignedFormatted({required String symbol, int decimalDigits = 4}) {
    final sign = this >= 0 ? '+' : '-';
    final floored = (this * pow(10, decimalDigits)).floor() / pow(10, decimalDigits);
    final absFloored = floored.abs();
    return '$sign $absFloored $symbol';
  }

// 1.23 ₽
  String formatted({String locale = 'ru_RU'}) {
    return NumberFormat.currency(locale: locale, symbol: '₽', decimalDigits: 2).format(this);
  }

// 1.23 тыс.
  String compact({String locale = 'ru_RU'}) {
    return NumberFormat.compact(locale: locale).format(this);
  }

// 1.23 тыс. ₽
  String compactFormatted({String locale = 'ru_RU'}) {
    return NumberFormat.compactCurrency(locale: locale, symbol: '₽', decimalDigits: 2).format(this);
  }
}
