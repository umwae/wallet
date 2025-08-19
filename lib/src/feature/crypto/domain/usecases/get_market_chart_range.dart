import 'package:stonwallet/src/feature/crypto/domain/entities/chart_data_entity.dart';
import 'package:stonwallet/src/feature/crypto/domain/repositories/coingecko_repository.dart';

class GetMarketChartRangeUseCase {
  final CoinGeckoRepository _repository;

  GetMarketChartRangeUseCase(this._repository);

  Future<ChartDataEntity> call({
    required String id,
    required String vsCurrency,
    required String from,
    required String to,
    String? interval,
  }) =>
      _repository.getMarketChartRange(id, vsCurrency, from, to, interval);
}
