import 'package:stonwallet/src/core/constant/api_keys.dart';
import 'package:stonwallet/src/core/service/secure_storage_service.dart';
import 'package:tonutils/tonutils.dart';

class OpenTonWalletUseCase {
  final SecureStorageService secureStorage;

  OpenTonWalletUseCase({required this.secureStorage});

  Future<WalletContractV4R2> call() async {
    var mnemonics = await secureStorage.getMnemonics();
    // if (mnemonics == null) {
    // Генерируем новые мнемоники
    // mnemonics = Mnemonic.generate();
    mnemonics = tonkeeperMnemonics.split(' ');//Костыль для тестов
    //   await secureStorage.saveMnemonics(mnemonics.join(' '));
    // }
    final keyPair = Mnemonic.toKeyPair(mnemonics);
    final wallet = WalletContractV4R2.create(publicKey: keyPair.publicKey);
    final client = TonJsonRpc('https://testnet.toncenter.com/api/v2/jsonRPC', testnetApiKey);
    final opened = client.open(wallet);
    return opened;
  }
}
