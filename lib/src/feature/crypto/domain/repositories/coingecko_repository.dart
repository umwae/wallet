import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';

import '../../data/models/coingecko_coin.dart';

abstract class CoinGeckoRepository {
  Future<void> authenticate();
  Future<List<CoinGeckoCoin>> getCoinsList();
  Future<CoinGeckoDetails> getCoinById(String id);
}
