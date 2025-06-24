import '../../domain/repositories/coingecko_repository.dart';
import '../datasources/coingecko_api_service.dart';

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
}
