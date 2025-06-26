import 'package:stonwallet/src/feature/crypto/domain/repositories/coingecko_repository.dart';

class PingCoinGeckoUseCase {
  final CoinGeckoRepository _repository;

  PingCoinGeckoUseCase(this._repository);

  Future<void> call() => _repository.ping();
}
