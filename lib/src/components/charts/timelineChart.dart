// import 'package:charts_flutter/flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

import '../../class/transactionClass.dart';

class TimelineChart extends StatelessWidget {
  TimelineChart(this.data, {super.key});

  List<transactionClass> data;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(barGroups: _createTimelineChart(data)),
    );
    // return BarChart(_createTimelineChart(data));
  }
}

List<BarChartGroupData> _createTimelineChart(List<transactionClass> data) {
  List<BarChartGroupData> result = List.generate(data.length, (index) {
    return BarChartGroupData(x: index, groupVertically: true, barRods: [
      BarChartRodData(toY: data[index].transactionAmount.toDouble())
    ]);
  });

  return result;
  // return [
  //   Series<transactionClass, String>(
  //     id: 'TimelineChart',
  //     colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
  //     domainFn: (transactionClass transaction, _) =>
  //         transaction.transactionDate,
  //     measureFn: (transactionClass transaction, _) =>
  //         transaction.transactionAmount,
  //     data: data,
  //   )
  // ];
}
