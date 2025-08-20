import 'package:fl_chart/fl_chart.dart';

class ChartDataEntity {
  final List<FlSpot> spotsNormalized;
  Map<double, double> spotToPrice = {};
  double diff;
  double diffPercent;
  bool isDiffPositive;
  ChartDataEntity({
    required this.spotToPrice,
    required this.spotsNormalized,
    required this.diff,
    required this.diffPercent,
    required this.isDiffPositive,
  });
}
