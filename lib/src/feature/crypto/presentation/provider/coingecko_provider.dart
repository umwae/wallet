import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import '../../domain/usecases/authenticate_coingecko_usecase.dart';
import '../bloc/coingecko_auth_bloc.dart';

class CoinGeckoProviderWidget extends StatelessWidget {
  final Widget child;
  final AuthenticateCoinGeckoUseCase authenticateUseCase;
  const CoinGeckoProviderWidget({required this.child, required this.authenticateUseCase, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinGeckoAuthBloc>(
          create: (_) => CoinGeckoAuthBloc(authenticateUseCase),
        ),
      ],
      child: child,
    );
  }
}
