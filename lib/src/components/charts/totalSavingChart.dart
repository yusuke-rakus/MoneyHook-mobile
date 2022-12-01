import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';

class TotalSavingChart extends StatelessWidget {
  const TotalSavingChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Sample> data = [
      Sample(DateTime(2020, 9, 1), 1),
      Sample(DateTime(2020, 10, 1), 4),
      Sample(DateTime(2020, 11, 1), 5),
      Sample(DateTime(2020, 12, 1), 10),
    ];

    return TimeSeriesChart(
      _createSampleData(data),
      // defaultRenderer: ArcRendererConfig(arcWidth: 20),
    );
  }
}

class Sample {
  DateTime time;
  int sales;

  Sample(this.time, this.sales);
}

List<Series<Sample, DateTime>> _createSampleData(List<Sample> data) {
  return [
    Series<Sample, DateTime>(
      id: 'Sales',
      domainFn: (Sample sales, _) => sales.time,
      measureFn: (Sample sales, _) => sales.sales,
      data: data,
    )
  ];
}
