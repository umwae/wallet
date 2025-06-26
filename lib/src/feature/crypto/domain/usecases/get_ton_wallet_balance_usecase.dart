import 'package:stonwallet/src/core/utils/logger.dart';
import 'package:tonutils/tonutils.dart' show WalletContractV4R2;

class GetTonWalletBalanceUseCase {
  final Logger? logger;

  GetTonWalletBalanceUseCase({this.logger});

  Future<double?> call(WalletContractV4R2 openedWallet) async {
    try {
      final balanceNano  = await openedWallet.getBalance();
      final balance = balanceNano / BigInt.from(1e9.toInt());
      final addr = openedWallet.address.toString(isUrlSafe: true, isBounceable: true, isTestOnly: true);
      logger?.info('Wallet address: $addr, balance: $balance, workChain: ${openedWallet.workChain}');
      return balance;
    } on Object catch (e, stackTrace) {
      logger?.error(e.toString(), stackTrace: stackTrace);
      rethrow;
    }
  }
}
