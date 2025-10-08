import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/widget/app_loader.dart';
import 'package:stonwallet/src/core/widget/app_snackbar.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/create_transfer_usecase.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/send/confirm_sending_view.dart';
import 'package:stonwallet/src/feature/send/cubit/confirm_sending_cubit.dart';

class ConfirmSendingScope extends StatelessWidget {
  final String? addressArg;

  const ConfirmSendingScope([this.addressArg, Key? key]) : super(key: key);

// confirm_sending_scope.dart

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final createTransferUsecase =
        CreateTransferUsecase(deps.tonWalletRepository, secureStorage: deps.secureStorage);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, Object?>?;
    final address = addressArg ?? args?['address'] as String?;
    return BlocProvider(
      create: (_) => TransferCubit(createTransferUsecase),
      child: BlocListener<TransferCubit, TransferState>(
        listener: (context, state) {
          if (state is TransferIdle && state.amount != null) {
            // Если произошел перевод средств показываем snackbar и закрываем страницу
            ScaffoldMessenger.of(context).showSnackBar(
              AppSnackBar('Отправлены ${state.amount} TON по адресу $address', context),
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<TransferCubit, TransferState>(
          builder: (context, state) {
            if (state is TransferIdle) {
              return ConfirmSendingView(address: address);
            } else if (state is TransferError) {
              return ConfirmSendingView(
                address: address,
                showSnackbarCallback: () => ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    AppSnackBar(state.message, context),
                  ),
              );
            } else {
              return const AppLoader.fullscreen();
            }
          },
        ),
      ),
    );
  }
}
