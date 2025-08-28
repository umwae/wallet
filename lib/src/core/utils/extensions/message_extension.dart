import 'dart:convert';
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
    } catch (_) {
      return null;
    }
  }
}
