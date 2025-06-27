import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_coin_details_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_ton_wallet_balance_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/open_ton_wallet_usecase.dart';

// Events
sealed class WalletEvent {}

class WalletLoadDataEvent extends WalletEvent {}

// States
sealed class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletFailure extends WalletState {
  final String error;
  WalletFailure(this.error);
}

class WalletLoaded extends WalletState {
  final Map<String, double?> balances;
  final List<CoinGeckoDetails> coins;

  WalletLoaded({
    required this.balances,
    required this.coins,
  });
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetCoinDetailsUseCase _getCoinDetails;
  final GetTonWalletBalanceUseCase _getTonWalletBalance;
  final OpenTonWalletUseCase _openTonWallet;

  WalletBloc({
    required GetCoinDetailsUseCase getCoinDetails,
    required GetTonWalletBalanceUseCase getTonWalletBalance,
    required OpenTonWalletUseCase openTonWallet,
  })  : _getCoinDetails = getCoinDetails,
        _getTonWalletBalance = getTonWalletBalance,
        _openTonWallet = openTonWallet,
        super(WalletInitial()) {
    on<WalletLoadDataEvent>(_onLoadData);
  }

  Future<void> _onLoadData(
    WalletLoadDataEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());

    try {
      // Загружаем данные параллельно для оптимизации
      final openedWallet = await _openTonWallet.call();
      final ids = ['bitcoin', 'tether', 'the-open-network'];
      final results = await Future.wait([
        _getTonWalletBalance.call(openedWallet),
        Future.wait(ids.map(_getCoinDetails.call)),
      ]);

      final tonBalance = results[0] as double?;
      final coins = results[1] as List<CoinGeckoDetails>?;
      final balances = {
        'the-open-network': tonBalance,
      };

      emit(
        WalletLoaded(
          balances: balances,
          coins: coins ?? [],
        ),
      );
    } catch (e) {
      emit(WalletFailure(e.toString()));
    }
  }
}
