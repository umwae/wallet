import 'package:fl_chart/fl_chart.dart';
import 'package:stonwallet/src/feature/crypto/data/models/coingecko_market_chart_range.dart';
import 'package:stonwallet/src/feature/crypto/domain/entities/chart_data_entity.dart';

extension ChartDataMapper on CoinGeckoMarketChartRange {
  ChartDataEntity toChartPoints() {
    final pricesData = prices;
    final pricesExtracted = pricesData.map((element) => element[1]).toList();
    final minPrice = pricesExtracted.reduce((a, b) => a < b ? a : b).toDouble();
    final maxPrice = pricesExtracted.reduce((a, b) => a > b ? a : b).toDouble();
    final startingDate = DateTime.fromMillisecondsSinceEpoch(pricesData.first[0] as int);
    final endDateRaw =
        DateTime.fromMillisecondsSinceEpoch(pricesData.last[0] as int).difference(startingDate);
    final endDate = endDateRaw.inMilliseconds / Duration.millisecondsPerDay;
    //Даты в промежутке от 0 до последней даты в днях. Цены в промежутке от наименьшей до наибольшей.
    final spotsNormalized = pricesData.map(
      (List<num> p) {
        final timeSinceStartDate = DateTime.fromMillisecondsSinceEpoch(p[0] as int)
            .difference(DateTime.fromMillisecondsSinceEpoch(pricesData.first[0] as int));
        final daysPrecise = timeSinceStartDate.inMilliseconds / Duration.millisecondsPerDay;

        final pricesNormalized = (p[1] - minPrice) / (maxPrice - minPrice) * 100;
        final flSpot = FlSpot(daysPrecise, pricesNormalized);
        return flSpot;
      },
    ).toList();

    // Формируем 100 корзин по X (0..100)
    const bucketCount = 100;
    final bucketsY = List.generate(bucketCount, (_) => <double>[]);
    final bucketsRealPrice = List.generate(bucketCount, (_) => <double>[]);
    for (var i = 0; i < spotsNormalized.length; i++) {
      final spot = spotsNormalized[i];
      final bucketIdx = (spot.x / endDate * (bucketCount - 1)).round().clamp(0, bucketCount - 1);
      bucketsY[bucketIdx].add(spot.y);
      final realPrice = pricesData[i][1].toDouble();
      bucketsRealPrice[bucketIdx].add(realPrice);
    }
    // Усредняем Y в каждой корзине, получая 100 точек (а по-хорошему тут нужен LTTB Downsampling)
    final spotsNormalizedDeduped = <FlSpot>[];
    final spotToPrice = <double, double>{};
    for (var i = 0; i < bucketCount; i++) {
      if (bucketsY[i].isNotEmpty) {
        final avgY = bucketsY[i].reduce((a, b) => a + b) / bucketsY[i].length;
        spotsNormalizedDeduped.add(FlSpot(i.toDouble(), avgY));
        final avgPrice = bucketsRealPrice[i].reduce((a, b) => a + b) / bucketsRealPrice[i].length;
        spotToPrice[i.toDouble()] = avgPrice;
      }
    }
    return ChartDataEntity(spotToPrice, spotsNormalizedDeduped);
  }
}
