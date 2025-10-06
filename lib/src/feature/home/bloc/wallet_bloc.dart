import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/exceptions/app_exception.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_details.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_coin_details_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_ton_wallet_balance_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/open_ton_wallet_usecase.dart';

// Events
sealed class WalletEvent {}

class WalletLoadDataEvent extends WalletEvent {}

class WalletFilterEvent extends WalletEvent {
  final int? filter;
  WalletFilterEvent(this.filter);
}

// States
class WalletState {
  final WalletFilter filter;
  WalletState({this.filter = WalletFilter.all});

  WalletState copyWith({
    WalletFilter? filter,
  }) {
    return WalletState(
      filter: filter ?? this.filter,
    );
  }
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletFailure extends WalletState {
  final String error;
  WalletFailure(this.error);
}

class WalletLoaded extends WalletState {
  final Map<String, double?> balances;
  final List<CoinGeckoDetails> coins;
  final String address;

  WalletLoaded({
    required this.balances,
    required this.coins,
    required this.address,
    super.filter,
  });

  @override
  WalletLoaded copyWith({
    WalletFilter? filter,
    Map<String, double?>? balances,
    List<CoinGeckoDetails>? coins,
    String? address,
  }) {
    return WalletLoaded(
      filter: filter ?? this.filter,
      balances: balances ?? this.balances,
      coins: coins ?? this.coins,
      address: address ?? this.address,
    );
  }

  List<CoinGeckoDetails> get filteredCoins => filter.coinIds.isEmpty
      ? coins
      : coins.where((coin) => filter.coinIds.contains(coin.id)).toList();
}

enum WalletFilter {
  all([]),
  tonBased(['the-open-network']);

  final List<String> coinIds;
  const WalletFilter(this.coinIds);
  String get name {
    switch (this) {
      case WalletFilter.all:
        return 'Все активы';
      case WalletFilter.tonBased:
        return 'TON based';
    }
  }
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetCoinDetailsUseCase _getCoinDetailsUseCase;
  final GetTonWalletBalanceUseCase _getTonWalletBalanceUseCase;
  final OpenTonWalletUseCase _openTonWalletUseCase;

  WalletBloc({
    required GetCoinDetailsUseCase getCoinDetailsUseCase,
    required GetTonWalletBalanceUseCase getTonWalletBalanceUseCase,
    required OpenTonWalletUseCase openTonWalletUseCase,
  })  : _getCoinDetailsUseCase = getCoinDetailsUseCase,
        _getTonWalletBalanceUseCase = getTonWalletBalanceUseCase,
        _openTonWalletUseCase = openTonWalletUseCase,
        super(WalletInitial()) {
    on<WalletLoadDataEvent>(_onLoadData);
    on<WalletFilterEvent>(_onSetFilter);
  }

  Future<void> _onLoadData(
    WalletLoadDataEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());

    try {
      // Загружаем данные параллельно для оптимизации
      final openedWallet = await _openTonWalletUseCase.call();
      final ids = [
        'bitcoin',
        'tether',
        'the-open-network',
        'ethereum',
        'solana',
        'ripple',
      ];
      final results = await Future.wait([
        _getTonWalletBalanceUseCase.call(openedWallet),
        Future.wait(ids.map(_getCoinDetailsUseCase.call)),
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
          address:
              openedWallet.address.toString(isUrlSafe: true, isBounceable: true, isTestOnly: true),
        ),
      );
    } on AppException catch (e) {
      emit(WalletFailure(e.message));
      rethrow;
    }
  }

  Future<void> _onSetFilter(
    WalletFilterEvent event,
    Emitter<WalletState> emit,
  ) async {
    if (event.filter == null) return;

    final newFilter = WalletFilter.values[event.filter!];

    if (state is WalletLoaded) {
      emit((state as WalletLoaded).copyWith(filter: newFilter));
    } else {
      emit(state.copyWith(filter: newFilter));
    }
  }
}
