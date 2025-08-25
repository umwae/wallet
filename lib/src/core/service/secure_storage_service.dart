import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tonutils/tonutils.dart' show KeyPair;
import 'dart:convert';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveApiKey(String key) async {
    await _storage.write(key: 'api_key', value: key);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: 'api_key');
  }

  //Ключи генерируются из мнемоник
  Future<void> saveKeyPair(KeyPair key) async {
    await _storage.write(
      key: 'key_pair',
      value: jsonEncode({
        'publicKey': base64Encode(key.publicKey),
        'privateKey': base64Encode(key.privateKey),
      }),
    );
  }
  //Ключи генерируются из мнемоник
  Future<KeyPair?> getKeyPair() async {
    final keyPairString = await _storage.read(key: 'key_pair');
    if (keyPairString == null) return null;
    final map = jsonDecode(keyPairString) as Map<String, dynamic>;
    return KeyPair(
      publicKey: base64Decode(map['publicKey'] as String),
      privateKey: base64Decode(map['privateKey'] as String),
    );
  }
}
