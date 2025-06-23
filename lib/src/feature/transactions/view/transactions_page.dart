import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';
import 'package:stonwallet/src/feature/transactions/transactions.dart';

/// {@template counter_page}
/// A [StatelessWidget] which is responsible for providing a
/// [TransactionsCubit] instance to the [TransactionsView].
/// {@endtemplate}
class TransactionsPage extends BasePage {
  /// {@macro counter_page}
  const TransactionsPage({super.key});
  // static Route<void> route() {
  //   return MaterialPageRoute<void>(builder: (_) => const TransactionsPage());
  // }
  @override
  Widget buildContent(BuildContext context) {
    return TransactionsView();
    // return BlocProvider(
    //   create: (_) => TransactionsCubit(),
    //   child: const TransactionsView(),
    // );
  }
}