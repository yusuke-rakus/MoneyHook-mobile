import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';

import '../../class/savingTargetClass.dart';

class TotalSavingChart extends StatelessWidget {
  TotalSavingChart(this.data, {super.key});

  List<savingTargetClass> data;

  @override
  Widget build(BuildContext context) {
    return TimeSeriesChart(
      _createTotalSavingData(data),
    );
  }
}

List<Series<savingTargetClass, DateTime>> _createTotalSavingData(
    List<savingTargetClass> data) {
  return [
    Series<savingTargetClass, DateTime>(
      id: 'TotalSavingChart',
      domainFn: (savingTargetClass savingTarget, _) => savingTarget.savingMonth,
      measureFn: (savingTargetClass savingTarget, _) =>
          savingTarget.monthlyTotalSavingAmount,
      data: data,
    )
  ];
}
