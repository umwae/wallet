import 'package:stonwallet/src/feature/crypto/data/models/coingecko_coin.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';

abstract class CoinGeckoRepository {
  Future<void> ping();
  Future<List<CoinGeckoCoin>> getCoinsList();
  Future<CoinGeckoDetails> getCoinById(String id);
}
