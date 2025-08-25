import 'package:stonwallet/src/core/utils/logger.dart';
import 'package:stonwallet/src/feature/crypto/domain/repositories/ton_wallet_repository.dart';
import 'package:tonutils/tonutils.dart' show WalletContractV4R2;

class GetTonWalletBalanceUseCase {
  final Logger? logger;
  final TonWalletRepository repository;

  GetTonWalletBalanceUseCase(this.repository, {this.logger});

  Future<double?> call(WalletContractV4R2 openedWallet) async {
    return repository.getBalance(openedWallet);
  }
}
