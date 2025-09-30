import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/create_transfer_usecase.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/send/confirm_sending_view.dart';
import 'package:stonwallet/src/feature/send/cubit/confirm_sending_cubit.dart';

class ConfirmSendingScope extends StatelessWidget {
  final String? addressArg;

  const ConfirmSendingScope([this.addressArg, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final createTransferUsecase =
        CreateTransferUsecase(deps.tonWalletRepository, secureStorage: deps.secureStorage);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, Object?>?;
    final address = addressArg ?? args?['address'] as String?;
    return BlocProvider(
      create: (_) => TransferCubit(createTransferUsecase),
      child: ConfirmSendingView(address: address),
    );
  }
}
