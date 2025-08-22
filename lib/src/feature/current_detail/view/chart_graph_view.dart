// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/core/utils/extensions/app_theme_extension.dart';
import 'package:stonwallet/src/core/utils/extensions/double_extension.dart';
import 'package:stonwallet/src/feature/current_detail/domain/entities/chart_data_entity.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_cubit.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';

class ChartGraphView extends StatefulWidget {
  const ChartGraphView({super.key});

  @override
  State<ChartGraphView> createState() => _ChartGraphViewState();
}

class _ChartGraphViewState extends State<ChartGraphView> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final extraColors = theme.extension<ExtraColors>()!;
    // final gradientColors = [
    //   AppColors.contentColorCyan,
    //   AppColors.contentColorBlue,
    // ];
    final bullGradientColors = [
      extraColors.gradientGainColor,
      colorScheme.surface,
    ];
    final bearGradientColors = [
      extraColors.gradientLossColor,
      colorScheme.surface,
    ];

    return BlocBuilder<CurrentDetailCubit, int>(
      builder: (context, state) {
        return BlocBuilder<ChartGraphCubit, ChartGraphState>(
          builder: (context, chartState) {
            Widget chartWidget;
            if (chartState is ChartGraphLoading) {
              chartWidget = const Center(child: CircularProgressIndicator());
            } else if (chartState is ChartGraphLoaded) {
              chartWidget =
                  LineChart(mainData(chartState.chartData, bullGradientColors, bearGradientColors));
            } else if (chartState is ChartGraphError) {
              chartWidget = Center(child: Text(chartState.message));
            } else {
              chartWidget = const SizedBox.shrink();
            }
            return Column(
              children: [
                Row(
                  children: [
                    _periodChangeArrow(chartState, state, context),
                    SizedBox(width: 4),
                    _periodChangeText(chartState, state, context),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: chartWidget,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _PeriodTab(title: '1Д', index: 0, selectedIndex: state),
                    _PeriodTab(title: '7Д', index: 1, selectedIndex: state),
                    _PeriodTab(title: '1М', index: 2, selectedIndex: state),
                    _PeriodTab(title: '1Г', index: 3, selectedIndex: state),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta, List<double> prices) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 15,
    );
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final realPrice = minPrice + (maxPrice - minPrice) * (value / 100);
    return Text(realPrice.compactFormatted(locale: "en"), style: style, textAlign: TextAlign.right);
  }

  LineChartData mainData(
    ChartDataEntity chartData,
    List<Color> bullGradientColors,
    List<Color> bearGradientColors,
  ) {
    final extraColors = Theme.of(context).extension<ExtraColors>()!;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        // verticalInterval: 100.0 / chartData.spotToPrice.length - 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: extraColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: (value, meta) =>
                rightTitleWidgets(value, meta, chartData.spotToPrice.values.toList()),
            reservedSize: 56,
            maxIncluded: false,
            minIncluded: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      // maxX: chartData.spotToPrice.length.toDouble(),
      maxX: 100,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: chartData.spotsNormalized,
          isCurved: true,
          curveSmoothness: 0.2,
          color: chartData.isDiffPositive
              ? extraColors.contentColorGreen
              : extraColors.contentColorRed,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: (chartData.spotsNormalized.last.y >= chartData.spotsNormalized.first.y
                      ? bullGradientColors
                      : bearGradientColors)
                  .map((color) => color.withValues(alpha: 0.2))
                  .toList(),
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              final realPrice = chartData.spotToPrice[
                      ((chartData.spotToPrice.length - 1) / 100 * touchedSpot.x).round()] ??
                  99;
              return LineTooltipItem(
                realPrice.compactFormatted(locale: 'ru_RU'),
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  final String title;
  final int index;
  final int selectedIndex;

  const _PeriodTab({required this.title, required this.index, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final selected = (index == selectedIndex);
    return DecoratedBox(
      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => context.read<CurrentDetailCubit>().changePeriod(index),
        child: Text(title, style: TextStyle(color: selected ? Colors.white : Colors.white54)),
      ),
    );
  }
}

Widget _periodChangeArrow(ChartGraphState chartState, int periodIndex, BuildContext context) {
  final extraColors = Theme.of(context).extension<ExtraColors>()!;
  if (chartState is ChartGraphLoaded) {
    final data = chartState.chartData;
    final color = data.isDiffPositive ? extraColors.contentColorGreen : extraColors.contentColorRed;
    return Icon(
      data.isDiffPositive ? Icons.arrow_upward : Icons.arrow_downward,
      color: color,
      size: 16,
    );
  } else {
    return const SizedBox.shrink();
  }
}

Widget _periodChangeText(ChartGraphState chartState, int periodIndex, BuildContext context) {
  final extraColors = Theme.of(context).extension<ExtraColors>()!;
  if (chartState is ChartGraphLoaded) {
    final data = chartState.chartData;
    String periodLabel;
    switch (periodIndex) {
      case 0:
        periodLabel = 'За день';
      case 1:
        periodLabel = 'За 7 дней';
      case 2:
        periodLabel = 'За месяц';
      case 3:
        periodLabel = 'За год';
      default:
        periodLabel = 'За период';
    }
    final color = data.isDiffPositive ? extraColors.contentColorGreen : extraColors.contentColorRed;
    return Text(
      '${data.isDiffPositive ? '+' : ''}${data.diffPercent.toStringAsFixed(2)}%  ${data.isDiffPositive ? '+' : ''}${data.diff.formatted()}  $periodLabel',
      style: TextStyle(color: color, fontSize: 14),
    );
  }
  return const SizedBox.shrink();
}
