import 'package:stonwallet/src/feature/crypto/data/models/coingecko_coin.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/chart_data_entity.dart';

abstract class CoinGeckoRepository {
  Future<void> ping();
  Future<List<CoinGeckoCoin>> getCoinsList();
  Future<CoinGeckoDetails> getCoinById(String id);
  Future<ChartDataEntity> getMarketChartRange(
    String id,
    String vsCurrency,
    String from,
    String to,
    String? interval,
  );
}
