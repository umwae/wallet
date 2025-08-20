import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentDetailCubit extends Cubit<int> {
  CurrentDetailCubit() : super(0);

  void changePeriod(int periodIndex) => emit(periodIndex);
  void reset() => emit(0);
}