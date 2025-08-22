import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/usecases/get_market_chart_range.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_cubit.dart';
import 'package:stonwallet/src/feature/current_detail/view/chart_graph_view.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';

class ChartGraphScope extends StatelessWidget {
  final String id;
  final String vsCurrency;
  final String from;
  final String to;
  final String? interval;

  const ChartGraphScope({
    required this.id,
    required this.vsCurrency,
    required this.from,
    required this.to,
    this.interval,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final getMarketChartRangeUseCase = GetMarketChartRangeUseCase(deps.coinGeckoRepository);

    return BlocProvider(
      create: (_) => ChartGraphCubit(getMarketChartRangeUseCase)
        ..loadChart(
          id: id,
          vsCurrency: vsCurrency,
          from: from,
          to: to,
          interval: interval,
        ),
      child: const ChartGraphView(),
    );
  }
}
