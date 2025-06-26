import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveApiKey(String key) async {
    await _storage.write(key: 'api_key', value: key);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: 'api_key');
  }

  Future<void> saveMnemonics(String key) async {
    await _storage.write(key: 'mnemonics', value: key);
  }

  Future<List<String>?> getMnemonics() async {
    final mnemonics = await _storage.read(key: 'mnemonics');
    return mnemonics?.split(' ');
  }
}
