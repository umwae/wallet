import '../repositories/coingecko_repository.dart';
import '../../data/models/coingecko_details.dart';

class GetCoinDetailsUseCase {
  final CoinGeckoRepository _repository;

  GetCoinDetailsUseCase(this._repository);

  Future<CoinGeckoDetails> call(String id) => _repository.getCoinById(id);
}
