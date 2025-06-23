import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stonwallet/src/feature/current_detail/current_detail.dart';
import 'package:stonwallet/src/feature/current_detail/view/chart_graph.dart';

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
        return Column(
          children: [
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.70,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 0,
                      left: 0,
                      top: 0,
                      bottom: 12,
                    ),
                    child: LineChart(
                      // showAvg ? avgData() : mainData(),
                      mainData(spots),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PeriodTab(title: '1Д', index: 0, selectedIndex: state),
                _PeriodTab(title: '7Д', index: 1, selectedIndex: state),
                _PeriodTab(title: '1М', index: 2, selectedIndex: state),
                _PeriodTab(title: '1Г', index: 3, selectedIndex: state),
                _PeriodTab(title: 'Все', index: 4, selectedIndex: state),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.right);
  }

  LineChartData mainData(List<FlSpot> spots) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        // horizontalInterval: 1,
        verticalInterval: 100,
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
            // reservedSize: 6,
            // getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta, selectedIndex: periodIndex),
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: rightTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: spots.fold<double>(spots.first.x, (prev, spot) => spot.x > prev ? spot.x : prev),
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
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
              colors: (spots.last.y >= spots.first.y ? bullGradientColors : bearGradientColors)
                  .map((color) => color.withValues(alpha: 0.2))
                  .toList(),
            ),
          ),
        ),
      ],
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
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
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

final spots = const [
  FlSpot(0, 3),
  FlSpot(0.8, 2.5),
  FlSpot(1.2, 3.8),
  FlSpot(2.6, 2),
  FlSpot(3.4, 2.8),
  FlSpot(4.4, 4.2),
  FlSpot(4.9, 5),
  FlSpot(5.6, 4.5),
  FlSpot(6.2, 3.9),
  FlSpot(6.8, 3.1),
  FlSpot(7.5, 3.5),
  FlSpot(8, 4),
  FlSpot(8.5, 3.8),
  FlSpot(9, 3.4),
  FlSpot(9.5, 3),
  FlSpot(10.2, 3.7),
  FlSpot(11, 4),
];
