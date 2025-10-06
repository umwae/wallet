abstract class AppException implements Exception {
  final String message;
  final String? innerMessage;
  final Object? inner;
  final int? statusCode;
  final bool canRetry;

  const AppException(this.message,
      {this.innerMessage, this.inner, this.statusCode, this.canRetry = false});

  @override
  String toString() {
    return '[${super.runtimeType}] $message. ${innerMessage ?? ''}';
  }
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.inner, super.innerMessage}) : super(canRetry: true);
}

class ApiException extends AppException {
  const ApiException(super.message, {super.inner, super.innerMessage, super.statusCode})
      : super(canRetry: false);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message, {super.inner, super.innerMessage, super.statusCode});
}

class DataException extends AppException {
  final Map<String, String>? fields;
  const DataException(super.message, {this.fields, super.inner, super.innerMessage});
}

class UnknownException extends AppException {
  const UnknownException(super.message, {super.inner, super.innerMessage, super.statusCode});
}

class ParsingException extends AppException {
  const ParsingException(super.message, {super.inner, super.innerMessage, super.statusCode});
}

class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.inner, super.innerMessage, super.statusCode});
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.inner, super.innerMessage, super.statusCode});
}

class CancelledException extends ApiException {
  const CancelledException(super.message, {super.inner, super.innerMessage, super.statusCode});
}
