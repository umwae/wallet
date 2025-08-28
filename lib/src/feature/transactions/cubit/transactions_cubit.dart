import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/fetch_ton_transactions_usecase.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:tonutils/tonutils.dart' show InternalAddress;

class TransactionsCubit extends Cubit<List<TransactionEntity>> {
  final FetchTonTransactionsUseCase useCase;
  TransactionsCubit(this.useCase) : super([]);

  Future<void> fetchTransactions(InternalAddress address) async {
    final entities = await useCase.call(address);
    emit(entities);
  }
}
