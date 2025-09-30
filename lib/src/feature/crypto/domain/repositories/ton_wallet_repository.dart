import 'package:stonwallet/src/core/service/secure_storage_service.dart' show SecureStorageService;
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:tonutils/tonutils.dart' show InternalAddress, WalletContractV4R2;

abstract class TonWalletRepository {
  Future<double?> getBalance(dynamic openedWallet);
  Future<WalletContractV4R2> openWallet(SecureStorageService secureStorage);
  Future<List<TransactionEntity>> fetchTransactions(InternalAddress address);
  Future<void> createTransfer(
    WalletContractV4R2 openedContract,
    String address,
    String amount,
    String message,
    SecureStorageService secureStorage,
  );
}
