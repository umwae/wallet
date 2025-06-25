import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_coin_details_usecase.dart';
import '../../data/models/coingecko_details.dart';

// Events
abstract class CoinGeckoCoinsEvent {}
class FetchCoinsDetailsEvent extends CoinGeckoCoinsEvent {}

// States
abstract class CoinGeckoCoinsState {}
class CoinGeckoCoinsInitial extends CoinGeckoCoinsState {}
class CoinGeckoCoinsLoading extends CoinGeckoCoinsState {}
class CoinGeckoCoinsLoaded extends CoinGeckoCoinsState {
  final List<CoinGeckoDetails> coins;
  CoinGeckoCoinsLoaded(this.coins);
}
class CoinGeckoCoinsFailure extends CoinGeckoCoinsState {
  final String error;
  CoinGeckoCoinsFailure(this.error);
}

class CoinGeckoCoinsBloc extends Bloc<CoinGeckoCoinsEvent, CoinGeckoCoinsState> {
  final GetCoinDetailsUseCase _getCoinDetailsUseCase;
  CoinGeckoCoinsBloc(this._getCoinDetailsUseCase) : super(CoinGeckoCoinsInitial()) {
    on<FetchCoinsDetailsEvent>(_onFetchCoinsDetails);
  }

  Future<void> _onFetchCoinsDetails(
    FetchCoinsDetailsEvent event,
    Emitter<CoinGeckoCoinsState> emit,
  ) async {
    emit(CoinGeckoCoinsLoading());
    try {
      final ids = ['bitcoin', 'tether', 'the-open-network'];
      final coins = await Future.wait(ids.map(_getCoinDetailsUseCase.call));
      emit(CoinGeckoCoinsLoaded(coins));
    } catch (e) {
      emit(CoinGeckoCoinsFailure(e.toString()));
    }
  }
}
