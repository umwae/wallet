import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/chart_data_entity.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_market_chart_range.dart';

abstract class ChartGraphState {}

class ChartGraphLoading extends ChartGraphState {}

class ChartGraphLoaded extends ChartGraphState {
  final ChartDataEntity chartData;
  ChartGraphLoaded(this.chartData);
}

class ChartGraphError extends ChartGraphState {
  final String message;
  ChartGraphError(this.message);
}

class ChartGraphCubit extends Cubit<ChartGraphState> {
  final GetMarketChartRangeUseCase useCase;
  ChartGraphCubit(this.useCase) : super(ChartGraphLoading());

  Future<void> loadChart({
    required String id,
    required String vsCurrency,
    required String from,
    required String to,
    String? interval,
  }) async {
    emit(ChartGraphLoading());
    try {
      final result = await useCase(
        id: id,
        vsCurrency: vsCurrency,
        from: from,
        to: to,
        interval: interval,
      );
      emit(ChartGraphLoaded(result));
    } catch (e) {
      emit(ChartGraphError('Ошибка загрузки графика: $e'));
    }
  }
}
