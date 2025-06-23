import 'package:bloc/bloc.dart';

/// {@template counter_cubit}
/// A [Cubit] which manages an [int] as its state.
/// {@endtemplate}
class CurrentDetailCubit extends Cubit<int> {
  /// {@macro counter_cubit}
  CurrentDetailCubit() : super(0);

  /// Add 1 to the current state.
  void changePeriod(int periodIndex) => emit(periodIndex);

  /// Subtract 1 from the current state.
  // void decrement() => emit(state - 1);

  /// Reset the state to 0.
  void reset() => emit(0);
}