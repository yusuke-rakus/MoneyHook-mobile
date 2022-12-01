import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';

class HomeChart extends StatelessWidget {
  const HomeChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Sample> data = [
      Sample('2020', 1),
      Sample('2021', 4),
      Sample('2022', 8),
      Sample('2023', 10),
    ];

    return PieChart(
      _createSampleData(data),
      // defaultRenderer: ArcRendererConfig(arcWidth: 20),
    );
  }
}

class Sample {
  String year;
  int sales;

  Sample(this.year, this.sales);
}

List<Series<Sample, String>> _createSampleData(List<Sample> data) {
  return [
    Series<Sample, String>(
      id: 'Sales',
      domainFn: (Sample sales, _) => sales.year,
      measureFn: (Sample sales, _) => sales.sales,
      data: data,
    )
  ];
}
