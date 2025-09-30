import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/create_transfer_usecase.dart';
import 'package:tonutils/tonutils.dart';

abstract class TransferState {}

class TransferLoading extends TransferState {}

class TransferIdle extends TransferState {
  String? amount;
  TransferIdle(this.amount);
}

class TransferError extends TransferState {
  final String message;
  TransferError(this.message);
}

class TransferCubit extends Cubit<TransferState> {
  final CreateTransferUsecase useCase;
  TransferCubit(this.useCase) : super(TransferLoading());

  Future<void> createTransfer({
    required WalletContractV4R2 openedContract,
    required String address,
    required String amount,
    required String message,
  }) async {
    emit(TransferLoading());
    try {
      final result = await useCase.call(
        openedContract,
        address,
        amount,
        message,
      );
      emit(TransferIdle(amount));
    } catch (e) {
      emit(TransferError('Ошибка перевода средств: $e'));
    }
  }
}
