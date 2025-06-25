class CoinGeckoCoin {
  final String id;
  final String symbol;
  final String name;
  final Map<String, dynamic> platforms;

  CoinGeckoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.platforms,
  });

  factory CoinGeckoCoin.fromJson(Map<String, dynamic> json) => CoinGeckoCoin(
        id: json['id'] as String,
        symbol: json['symbol'] as String,
        name: json['name'] as String,
        platforms: (json['platforms'] is Map)
            ? Map<String, dynamic>.from(json['platforms'] as Map)
            : <String, dynamic>{},
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'platforms': platforms,
      };
}
