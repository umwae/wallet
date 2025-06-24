import '../repositories/coingecko_repository.dart';

class AuthenticateCoinGeckoUseCase {
  final CoinGeckoRepository _repository;

  AuthenticateCoinGeckoUseCase(this._repository);

  Future<void> call() => _repository.authenticate();
}
