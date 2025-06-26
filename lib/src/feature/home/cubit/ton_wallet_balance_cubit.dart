import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TonWalletBalanceState {}
class TonWalletBalanceInitial extends TonWalletBalanceState {}
class TonWalletBalanceLoading extends TonWalletBalanceState {}
class TonWalletBalanceLoaded extends TonWalletBalanceState {
  final double? balance;
  TonWalletBalanceLoaded(this.balance);
}
class TonWalletBalanceError extends TonWalletBalanceState {
  final String error;
  TonWalletBalanceError(this.error);
}

class TonWalletBalanceCubit extends Cubit<TonWalletBalanceState> {
  final Future<double?> Function() loadBalance;
  TonWalletBalanceCubit({required this.loadBalance}) : super(TonWalletBalanceInitial());

  Future<void> fetchBalance() async {
    emit(TonWalletBalanceLoading());
    try {
      final balance = await loadBalance();
      emit(TonWalletBalanceLoaded(balance));
    } catch (e) {
      emit(TonWalletBalanceError(e.toString()));
    }
  }
}
