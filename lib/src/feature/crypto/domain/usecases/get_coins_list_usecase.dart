import '../repositories/coingecko_repository.dart';
import '../../data/models/coingecko_coin.dart';

class GetCoinsListUseCase {
  final CoinGeckoRepository _repository;

  GetCoinsListUseCase(this._repository);

  Future<List<CoinGeckoCoin>> call() => _repository.getCoinsList();
}
