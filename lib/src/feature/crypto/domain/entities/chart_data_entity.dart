import 'package:fl_chart/fl_chart.dart';

class ChartDataEntity {
  final List<FlSpot> spotsNormalized;
  Map<double, double> spotToPrice = {};
  ChartDataEntity(this.spotToPrice, this.spotsNormalized);
}
