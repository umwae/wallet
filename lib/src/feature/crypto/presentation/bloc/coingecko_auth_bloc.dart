import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/authenticate_coingecko_usecase.dart';

// Events
abstract class CoinGeckoAuthEvent {}

class AuthenticateCoinGeckoEvent extends CoinGeckoAuthEvent {}

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
  final AuthenticateCoinGeckoUseCase _authenticateUseCase;

  CoinGeckoAuthBloc(this._authenticateUseCase) : super(CoinGeckoAuthInitial()) {
    on<AuthenticateCoinGeckoEvent>(_onAuthenticate); //Регистрируем обработчик событий
    //Когда в блок поступит событие AuthenticateCoinGeckoEvent, будет вызван метод _onAuthenticate для обработки этого события
  }

  Future<void> _onAuthenticate(
    AuthenticateCoinGeckoEvent event,
    Emitter<CoinGeckoAuthState> emit,
  ) async {
    emit(CoinGeckoAuthLoading());

    try {
      await _authenticateUseCase();
      emit(CoinGeckoAuthSuccess());
    } catch (e) {
      emit(CoinGeckoAuthFailure(e.toString()));
    }
  }
}
