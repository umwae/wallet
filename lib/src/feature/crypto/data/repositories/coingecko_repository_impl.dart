import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';

import '../../domain/repositories/coingecko_repository.dart';
import '../datasources/coingecko_api_service.dart';
import '../models/coingecko_coin.dart';

class CoinGeckoRepositoryImpl implements CoinGeckoRepository {
  final CoinGeckoApiService _apiService;
  final String _apiKey;

  CoinGeckoRepositoryImpl(this._apiService, this._apiKey);

  @override
  Future<void> authenticate() async {
    try {
      await _apiService.ping(apiKey: _apiKey);
    } catch (e) {
      throw Exception('Failed to authenticate with CoinGecko API: $e');
    }
  }

  @override
  Future<List<CoinGeckoCoin>> getCoinsList() async {
    try {
      return await _apiService.getCoinsList(apiKey: _apiKey);
    } catch (e) {
      throw Exception('Failed to fetch coins list: $e');
    }
  }

  @override
  Future<CoinGeckoDetails> getCoinById(String id) async {
    try {
      return await _apiService.getCoinById(id: id, apiKey: _apiKey);
    } catch (e) {
      throw Exception('Failed to fetch coin details: $e');
    }
  }
}
