// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/chart_data_entity.dart';
import 'package:stonwallet/src/feature/current_detail/cubit/chart_graph_cubit.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  List<Color> bullGradientColors = [
    const Color.fromARGB(255, 114, 235, 101),
    const Color.fromARGB(255, 0, 0, 0),
  ];
  List<Color> bearGradientColors = [
    const Color.fromARGB(255, 255, 70, 70),
    const Color.fromARGB(255, 192, 10, 10),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentDetailCubit, int>(
      builder: (context, state) {
        return BlocBuilder<ChartGraphCubit, ChartGraphState>(
          builder: (context, chartState) {
            Widget chartWidget;
            if (chartState is ChartGraphLoading) {
              chartWidget = const Center(child: CircularProgressIndicator());
            } else if (chartState is ChartGraphLoaded) {
              chartWidget = LineChart(mainData(chartState.chartData));
            } else if (chartState is ChartGraphError) {
              chartWidget = Center(child: Text(chartState.message));
            } else {
              chartWidget = const SizedBox.shrink();
            }
            return Column(
              children: [
                Row(
                  children: [
                    _periodChangeArrow(chartState, state),
                    SizedBox(width: 4),
                    _periodChangeText(chartState, state),
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
    return Text(realPrice.toStringAsFixed(2), style: style, textAlign: TextAlign.right);
  }

  LineChartData mainData(ChartDataEntity chartData) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        // verticalInterval: 100.0 / chartData.spotToPrice.length - 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
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
          color: AppColors.contentColorGreen,
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
                '${realPrice.toStringAsFixed(2)}₽',
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

Widget _periodChangeArrow(ChartGraphState chartState, int periodIndex) {
  if (chartState is ChartGraphLoaded) {
    final data = chartState.chartData;
    final color = data.isDiffPositive ? Colors.green : Colors.red;
    return Icon(
      data.isDiffPositive ? Icons.arrow_upward : Icons.arrow_downward,
      color: color,
      size: 16,
    );
  } else {
    return const SizedBox.shrink();
  }
}

Widget _periodChangeText(ChartGraphState chartState, int periodIndex) {
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
    final color = data.isDiffPositive ? Colors.green : Colors.red;
    return Text(
      '${data.isDiffPositive ? '+' : ''}${data.diffPercent.toStringAsFixed(2)}%  ${data.isDiffPositive ? '+' : ''}${data.diffPercent.toStringAsFixed(2)} ₽  $periodLabel',
      style: TextStyle(color: color, fontSize: 14),
    );
  }
  return const SizedBox.shrink();
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
