import 'package:stonwallet/src/feature/crypto/data/datasources/coingecko_api_service.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_coin.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';
import 'package:stonwallet/src/feature/crypto/domain/mappers/chart_data_mapper.dart';
import 'package:stonwallet/src/feature/crypto/domain/repositories/coingecko_repository.dart';
import 'package:stonwallet/src/feature/current_detail/domain/entities/chart_data_entity.dart';

class CoinGeckoRepositoryImpl implements CoinGeckoRepository {
  final CoinGeckoApiService _apiService;
  final String _apiKey;

  CoinGeckoRepositoryImpl(this._apiService, this._apiKey);

  @override
  Future<void> ping() async {
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

  @override
  Future<ChartDataEntity> getMarketChartRange(
    String id,
    String vsCurrency,
    String from,
    String to,
    String? interval,
  ) async {
    try {
      return (await _apiService.getMarketChartRange(
        id: id,
        vsCurrency: vsCurrency,
        from: from,
        to: to,
        apiKey: _apiKey,
        precision: 'full',
        interval: interval,
      ))
          .toChartPoints();
    } catch (e) {
      throw Exception('Failed to fetch coin history chart: $e');
    }
  }
}
