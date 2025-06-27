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
    final formatter = numberFormat ?? NumberFormat.currency(
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
}
