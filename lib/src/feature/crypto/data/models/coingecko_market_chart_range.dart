import 'package:json_annotation/json_annotation.dart';

part 'coingecko_market_chart_range.g.dart';

@JsonSerializable()
class CoinGeckoMarketChartRange {
  @JsonKey(defaultValue: [])
  List<List<num>> prices = [];
  @JsonKey(defaultValue: [])
  List<List<num>> marketCaps = [];
  @JsonKey(defaultValue: [])
  List<List<num>> totalVolumes = [];

  CoinGeckoMarketChartRange({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });

  factory CoinGeckoMarketChartRange.fromJson(Map<String, dynamic> json) =>
      _$CoinGeckoMarketChartRangeFromJson(json);
  Map<String, dynamic> toJson() => _$CoinGeckoMarketChartRangeToJson(this);
}
