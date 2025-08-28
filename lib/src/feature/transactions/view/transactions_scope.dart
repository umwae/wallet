import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/fetch_ton_transactions_usecase.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/transactions/cubit/transactions_cubit.dart';
import 'package:stonwallet/src/feature/transactions/view/transactions_view.dart';

class TransactionsScope extends StatelessWidget {
  const TransactionsScope({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final fetchTonTransactionsUseCase = FetchTonTransactionsUseCase(deps.tonWalletRepository);

    return BlocProvider(
      create: (_) => TransactionsCubit(fetchTonTransactionsUseCase)
        ..fetchTransactions(deps.openedWallet.address),
      child: TransactionsView(),
    );
  }
}
