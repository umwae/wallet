import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/exceptions/app_exception.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/ping_coingecko_usecase.dart';

// Events
abstract class CoinGeckoAuthEvent {}

class PingCoinGeckoEvent extends CoinGeckoAuthEvent {}

// States
abstract class CoinGeckoAuthState {}

class CoinGeckoAuthInitial extends CoinGeckoAuthState {}

class CoinGeckoAuthLoading extends CoinGeckoAuthState {}

class CoinGeckoAuthSuccess extends CoinGeckoAuthState {}

class CoinGeckoAuthFailure extends CoinGeckoAuthState {
  final String error;

  CoinGeckoAuthFailure(this.error);
}

class CoinGeckoAuthBloc extends Bloc<CoinGeckoAuthEvent, CoinGeckoAuthState> {
  final PingCoinGeckoUseCase _authenticateUseCase;

  CoinGeckoAuthBloc(this._authenticateUseCase) : super(CoinGeckoAuthInitial()) {
    on<PingCoinGeckoEvent>(_onAuthenticate); //Регистрируем обработчик событий
    //Когда в блок поступит событие PingCoinGeckoEvent, будет вызван метод _onAuthenticate для обработки этого события
  }

  Future<void> _onAuthenticate(
    PingCoinGeckoEvent event,
    Emitter<CoinGeckoAuthState> emit,
  ) async {
    emit(CoinGeckoAuthLoading());
    try {
      await _authenticateUseCase();
      emit(CoinGeckoAuthSuccess());
    } on AppException catch (e) {
      emit(CoinGeckoAuthFailure(e.message));
      rethrow;
    }
  }
}
