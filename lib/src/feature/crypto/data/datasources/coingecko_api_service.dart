import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'coingecko_api_service.g.dart';

@RestApi(baseUrl: 'https://api.coingecko.com/api/v3')
abstract class CoinGeckoApiService {
  factory CoinGeckoApiService(Dio dio, {String baseUrl}) = _CoinGeckoApiService;

  @GET('/ping')
  Future<void> ping({
    @Header('x-cg-demo-api-key') required String apiKey,
  });
}
