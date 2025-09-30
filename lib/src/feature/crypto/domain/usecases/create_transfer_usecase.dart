import 'package:stonwallet/src/core/service/secure_storage_service.dart';
import 'package:stonwallet/src/core/utils/logger.dart';
import 'package:stonwallet/src/feature/crypto/domain/repositories/ton_wallet_repository.dart';
import 'package:tonutils/tonutils.dart' show WalletContractV4R2;

class CreateTransferUsecase {
  final Logger? logger;
  final TonWalletRepository repository;

  final SecureStorageService secureStorage;

  CreateTransferUsecase(
    this.repository, {
    required this.secureStorage,
    this.logger,
  });

  Future<void> call(
    final WalletContractV4R2 openedContract,
    final String address,
    final String amount,
    final String message,
  ) =>
      repository.createTransfer(openedContract, address, amount, message, secureStorage);
}
