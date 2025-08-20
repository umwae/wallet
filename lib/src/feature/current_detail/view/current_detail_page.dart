import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_market_chart_range.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_cubit.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';

class CurrentDetailPage extends StatelessWidget {
  const CurrentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final getMarketChartRangeUseCase = GetMarketChartRangeUseCase(deps.coinGeckoRepository);
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentDetailCubit>(create: (_) => CurrentDetailCubit()),
        BlocProvider<ChartGraphCubit>(create: (_) => ChartGraphCubit(getMarketChartRangeUseCase)),
      ],
      child: const CurrentDetailView(),
    );
  }
}
