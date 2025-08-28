import 'package:stonwallet/src/feature/crypto/domain/repositories/ton_wallet_repository.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:tonutils/tonutils.dart';

class FetchTonTransactionsUseCase {
  final TonWalletRepository repository;

  FetchTonTransactionsUseCase(this.repository);

  Future<List<TransactionEntity>> call(InternalAddress address) async {
    return await repository.fetchTransactions(address);
  }
}
