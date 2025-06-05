import 'package:http/http.dart' as http;
import 'package:stonwallet/src/core/rest_client/rest_client.dart';

// coverage:ignore-start
/// Checks the [http.ClientException] and tries to parse it.
Object? checkHttpException(http.ClientException e) {
  if (e.message.contains('XMLHttpRequest error')) {
    return ConnectionException(message: e.message, cause: e);
  }

  return null;
}
// coverage:ignore-end
