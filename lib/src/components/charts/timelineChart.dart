import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';

import '../../class/transactionClass.dart';

class TimelineChart extends StatelessWidget {
  TimelineChart(this.data, {super.key});

  List<transactionClass> data;

  @override
  Widget build(BuildContext context) {
    return BarChart(_createTimelineChart(data));
  }
}

List<Series<transactionClass, String>> _createTimelineChart(
    List<transactionClass> data) {
  return [
    Series<transactionClass, String>(
      id: 'TimelineChart',
      colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
      domainFn: (transactionClass transaction, _) =>
          transaction.transactionDate,
      measureFn: (transactionClass transaction, _) =>
          transaction.transactionAmount,
      data: data,
    )
  ];
}
