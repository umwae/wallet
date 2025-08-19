import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_coin.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_market_chart_range.dart';

part 'coingecko_api_service.g.dart';

@RestApi(baseUrl: 'https://api.coingecko.com/api/v3')
abstract class CoinGeckoApiService {
  factory CoinGeckoApiService(Dio dio, {String baseUrl}) = _CoinGeckoApiService;

  @GET('/ping')
  Future<void> ping({
    @Header('x-cg-demo-api-key') required String apiKey,
  });

  @GET('/coins/list')
  Future<List<CoinGeckoCoin>> getCoinsList({
    @Header('x-cg-demo-api-key') required String apiKey,
  });

  @GET('/coins/{id}')
  Future<CoinGeckoDetails> getCoinById({
    @Path('id') required String id,
    @Header('x-cg-demo-api-key') required String apiKey,
    @Query('localization') bool localization = false,
    @Query('tickers') bool tickers = false,
    @Query('market_data') bool marketData = true,
    @Query('community_data') bool communityData = false,
    @Query('developer_data') bool developerData = false,
    @Query('sparkline') bool sparkline = false,
    @Query('dex_pair_format') String dexPairFormat = 'symbol',
  });

  @GET('/coins/{id}/market_chart/range')
  Future<CoinGeckoMarketChartRange> getMarketChartRange({
    @Path('id') required String id,
    @Header('x-cg-demo-api-key') required String apiKey,
    @Query('vs_currency') required String vsCurrency,
    @Query('from') required String from,
    @Query('to') required String to,
    @Query('precision') String? precision,
    @Query('interval') String? interval,
  });

}
