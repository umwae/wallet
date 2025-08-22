import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/coin_entity.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_market_chart_range.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_cubit.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';

class CurrentDetailScope extends StatelessWidget {
  final CoinEntity? coinEntityArg;

  const CurrentDetailScope([this.coinEntityArg, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final getMarketChartRangeUseCase = GetMarketChartRangeUseCase(deps.coinGeckoRepository);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, Object?>?;
    final coinEntity = coinEntityArg ?? args?['coinEntity'] as CoinEntity?;
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentDetailCubit>(create: (_) => CurrentDetailCubit()),
        BlocProvider<ChartGraphCubit>(create: (_) => ChartGraphCubit(getMarketChartRangeUseCase)),
      ],
      child:
          coinEntity != null ? CurrentDetailView(coinEntity: coinEntity) : const SizedBox.shrink(),
    );
  }
}
