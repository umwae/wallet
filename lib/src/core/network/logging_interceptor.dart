import 'package:dio/dio.dart';
import 'package:stonwallet/src/core/utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  final Logger logger;

  LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final logMessage = StringBuffer()
      ..writeln('🌐 HTTP Request')
      ..writeln('URL: ${options.uri}')
      ..writeln('Method: ${options.method}')
      ..writeln('Headers: ${options.headers}')
      ..writeln('Query Parameters: ${options.queryParameters}')
      ..writeln('Request Data: ${options.data}');

    logger.info(logMessage.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final logMessage = StringBuffer()
      ..writeln('✅ HTTP Response')
      ..writeln('URL: ${response.requestOptions.uri}')
      ..writeln('Status Code: ${response.statusCode}')
      ..writeln('Headers: ${response.headers}')
      ..writeln('Response Data: ${response.data}');

    logger.info(logMessage.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final logMessage = StringBuffer()
      ..writeln('❌ HTTP Error')
      ..writeln('URL: ${err.requestOptions.uri}')
      ..writeln('Status Code: ${err.response?.statusCode}')
      ..writeln('Error: ${err.error}')
      ..writeln('Response Data: ${err.response?.data}');

    logger.error(
      logMessage.toString(),
      error: err,
      stackTrace: err.stackTrace,
      printError: false,
    );
    super.onError(err, handler);
  }
}
