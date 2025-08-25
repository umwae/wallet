import 'package:stonwallet/src/core/service/secure_storage_service.dart' show SecureStorageService;
import 'package:tonutils/tonutils.dart' show WalletContractV4R2;

abstract class TonWalletRepository {
  Future<double?> getBalance(dynamic openedWallet);
  Future<WalletContractV4R2> openWallet(SecureStorageService secureStorage);
}
