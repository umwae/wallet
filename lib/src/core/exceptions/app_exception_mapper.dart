import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stonwallet/src/core/exceptions/app_exception.dart';

extension AppExceptionX on Object {
  AppException toAppException() => _mapToAppException(this);

  AppException _mapToAppException(Object exc) {
    // Dio
    if (exc is DioException) {
      switch (exc.type) {
        case DioExceptionType.cancel:
          return CancelledException('Запрос отменён', inner: exc, innerMessage: exc.message);
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return TimeoutException(
            'Истекло время ожидания',
            inner: exc,
          );
        case DioExceptionType.badResponse:
          final code = exc.response?.statusCode;
          if (code != null && code >= 500) {
            return ServerException('Проблемы на сервере', statusCode: code, inner: exc);
          }
          if (code == 401 || code == 403) {
            return ServerException('Недостаточно прав', statusCode: code, inner: exc);
          }
          return ServerException('Ошибка запроса', statusCode: code, inner: exc);
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionError:
          return NetworkException('Отсутствует соединение', inner: exc);
        case DioExceptionType.unknown:
          // Часто сюда попадает SocketException
          if (exc.error is SocketException) {
            return NetworkException('Проверьте подключение к интернету', inner: exc);
          }
          return UnknownException('Неизвестная ошибка', inner: exc);
      }
    }

    // Парсинг/формат
    if (exc is DataException || exc is TypeError) {
      return ParsingException('Ошибка обработки данных', inner: exc);
    }

    // Сокет/сеть
    if (exc is SocketException) {
      return NetworkException('Проблема с сетью', inner: exc);
    }

    // Таймауты dart:async
    if (exc is TimeoutException) {
      return TimeoutException('Истекло время ожидания', inner: exc);
    }

    return UnknownException('Неизвестная ошибка', inner: exc);
  }
}
