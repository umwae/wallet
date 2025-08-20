import 'package:flutter/material.dart' show Colors;
import 'package:intl/intl.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/coin_entity.dart';

extension CoinEntityMapper on CoinGeckoDetails {
  String get displayName => name;
  String get displaySymbol => symbol.toUpperCase();
  String get iconUrl => image.large;

  String priceInRubFormatted({String locale = 'ru_RU'}) {
    final price = marketData.currentPrice['rub'];
    if (price == null) return '-';
    return NumberFormat.currency(locale: locale, symbol: '₽', decimalDigits: 2).format(price);
  }

  String priceInRubValue() {
    final price = marketData.currentPrice['rub'];
    return price?.toStringAsFixed(2) ?? '';
  }

  String priceChangePercentage24hRub() {
    final value = marketData.priceChangePercentage24hInCurrency?['rub'] ?? 0.0;
    final sign = value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  CoinEntity toCoinEntity() {
    return CoinEntity(
        id: id,
        name: displayName,
        price: marketData.currentPrice['rub'].toString(),
        priceTrunc: priceInRubValue(),
        symbol: displaySymbol,
        priceFormatted: priceInRubFormatted(),
        iconURL: iconUrl,
        priceChangePercentage24h: priceChangePercentage24hRub(),
        coinBalance: 0.toString(),
        coinBalanceConverted: 0.toString(),
        earningsColor: Colors.transparent);
  }
}
