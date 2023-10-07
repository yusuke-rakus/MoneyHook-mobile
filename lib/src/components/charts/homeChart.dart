// import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class HomeChart extends StatelessWidget {
  HomeChart(this.data, {super.key});

  List<dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container();
    // return PieChart(
    //   _createHomeChart(data),
    // );
  }
}

// List<Series<dynamic, String>> _createHomeChart(List<dynamic> data) {
//   List<Color> colorList = [
//     ColorUtil.fromDartColor(Colors.redAccent),
//     ColorUtil.fromDartColor(Colors.lightBlue),
//     ColorUtil.fromDartColor(Colors.greenAccent),
//     ColorUtil.fromDartColor(Colors.indigo),
//     ColorUtil.fromDartColor(Colors.amber),
//     ColorUtil.fromDartColor(Colors.teal),
//     ColorUtil.fromDartColor(Colors.deepPurpleAccent),
//     ColorUtil.fromDartColor(Colors.grey),
//   ];
//
//   return [
//     Series<dynamic, String>(
//       id: 'HomeChart',
//       colorFn: (dynamic, i) => i! < colorList.length
//           ? colorList[i]
//           : colorList[colorList.length - 1],
//       domainFn: (dynamic value, _) => value['categoryName'],
//       measureFn: (dynamic value, _) => value['categoryTotalAmount'].abs(),
//       data: data,
//     )
//   ];
// }
