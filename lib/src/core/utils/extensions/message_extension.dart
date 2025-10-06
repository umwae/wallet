import 'dart:convert';
import 'package:stonwallet/src/core/exceptions/app_exception.dart';
import 'package:tonutils/tonutils.dart';

extension MessageComment on Message {
  String? get comment {
    try {
      final slice = body.beginParse();

      // op (uint32)
      final op = slice.loadUint(32);
      if (op != 0) {
        return null;
      }

      // query_id (uint64)
      slice.loadUint(64);

      // Остаток читаем как байты
      final remainingBytes = slice.loadList(slice.remainingBits ~/ 8);
      return utf8.decode(remainingBytes);
    } on Object catch (e, st) {
      Error.throwWithStackTrace(
        ParsingException('Failed to parse transaction message', inner: e),
        st,
      );
    }
  }
}
