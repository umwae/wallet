import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/widget/app_error_widget.dart';
import 'package:stonwallet/src/core/widget/app_loader.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_coin_details_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_ton_wallet_balance_usecase.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/open_ton_wallet_usecase.dart';
import 'package:stonwallet/src/feature/home/bloc/wallet_bloc.dart';
import 'package:stonwallet/src/feature/home/view/home_view.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';

class HomeScope extends StatelessWidget {
  const HomeScope({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final logger = deps.logger.withPrefix('[HOME]');

    final walletBloc = WalletBloc(
      getCoinDetailsUseCase: GetCoinDetailsUseCase(deps.coinGeckoRepository),
      getTonWalletBalanceUseCase:
          GetTonWalletBalanceUseCase(deps.tonWalletRepository, logger: logger),
      openTonWalletUseCase:
          OpenTonWalletUseCase(deps.tonWalletRepository, secureStorage: deps.secureStorage),
    );

    return BlocProvider(
      create: (_) => walletBloc..add(WalletLoadDataEvent()),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoaded) {
            return const HomeView();
          } else if (state is WalletFailure) {
            return AppErrorWidget.fullscreen(
              snackbarText: state.error,
              onRetry: () => walletBloc..add(WalletLoadDataEvent()),
            );
          } else {
            return const AppLoader.fullscreen();
          }
        },
      ),
    );
  }
}
