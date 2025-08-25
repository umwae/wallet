import 'package:stonwallet/src/core/service/secure_storage_service.dart';
import 'package:stonwallet/src/feature/crypto/domain/repositories/ton_wallet_repository.dart';
import 'package:tonutils/tonutils.dart';

class OpenTonWalletUseCase {
  final SecureStorageService secureStorage;
  final TonWalletRepository tonWalletRepository;

  OpenTonWalletUseCase(this.tonWalletRepository, {required this.secureStorage});

  Future<WalletContractV4R2> call() async {
    return await tonWalletRepository.openWallet(secureStorage);
  }
}
