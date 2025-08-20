import 'dart:ui' show Color;

class CoinEntity {
  final String id;
  final String name;
  final String priceFormatted;
  final String symbol;
  final String price;
  final String priceTrunc;
  String coinBalance;
  String coinBalanceConverted;
  final String? iconURL;
  final String? priceChangePercentage24h;
  Color earningsColor;

  CoinEntity({
    required this.id,
    required this.name,
    required this.priceFormatted,
    required this.symbol,
    required this.price,
    required this.priceTrunc,
    required this.coinBalance,
    required this.coinBalanceConverted,
    required this.earningsColor,
    this.iconURL,
    this.priceChangePercentage24h,
  });
}