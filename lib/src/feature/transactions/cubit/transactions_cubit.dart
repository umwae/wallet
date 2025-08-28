import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/fetch_ton_transactions_usecase.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:tonutils/tonutils.dart' show InternalAddress;

class TransactionsState {
  final List<TransactionEntity> transactions;
  final String? selectedFilter;

  const TransactionsState({
    required this.transactions,
    this.selectedFilter,
  });

  TransactionsState copyWith({
    List<TransactionEntity>? transactions,
    String? selectedFilter,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  List<TransactionEntity> get filteredTransactions {
    if (selectedFilter == null || selectedFilter == 'Все') return transactions;

    return transactions.where((tx) {
      switch (selectedFilter) {
        case 'Отправлено':
          return tx.type == TransactionType.outgoing;
        case 'Получено':
          return tx.type == TransactionType.incoming;
        default:
          return true;
      }
    }).toList();
  }
}

class TransactionsCubit extends Cubit<TransactionsState> {
  final FetchTonTransactionsUseCase useCase;
  TransactionsCubit(this.useCase)
      : super(const TransactionsState(transactions: [], selectedFilter: 'Все'));

  Future<void> fetchTransactions(InternalAddress address) async {
    final entities = await useCase.call(address);
    emit(state.copyWith(transactions: entities));
  }

  void setFilter(String? filter) {
    emit(state.copyWith(selectedFilter: filter));
  }
}
