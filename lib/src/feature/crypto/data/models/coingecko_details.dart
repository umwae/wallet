// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coingecko_details.freezed.dart';
part 'coingecko_details.g.dart';

@freezed
class CoinGeckoDetails with _$CoinGeckoDetails {
  const factory CoinGeckoDetails({
    required String id,
    required String symbol,
    required String name,
    @JsonKey(name: 'market_data') required MarketData marketData,
    required Image image,
  }) = _CoinGeckoDetails;

  factory CoinGeckoDetails.fromJson(Map<String, dynamic> json) => _$CoinGeckoDetailsFromJson(json);
}

@freezed
class MarketData with _$MarketData {
  const factory MarketData({
    @JsonKey(name: 'current_price') required Map<String, double> currentPrice,
    @JsonKey(name: 'price_change_24h') required double priceChange24h,
    @JsonKey(name: 'price_change_percentage_24h') required double priceChangePercentage24h,
    @JsonKey(name: 'market_cap') required Map<String, double> marketCap,
    @JsonKey(name: 'total_volume') required Map<String, double> totalVolume,
    @JsonKey(name: 'price_change_24h_in_currency') Map<String, double>? priceChange24hInCurrency,
    @JsonKey(name: 'price_change_percentage_24h_in_currency')
    Map<String, double>? priceChangePercentage24hInCurrency,
  }) = _MarketData;

  factory MarketData.fromJson(Map<String, dynamic> json) => _$MarketDataFromJson(json);
}

@freezed
class Image with _$Image {
  const factory Image({
    required String thumb,
    required String small,
    required String large,
  }) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
