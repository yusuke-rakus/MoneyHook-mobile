import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeChart extends StatefulWidget {
  HomeChart({super.key, required this.data, required this.colorList});

  List<dynamic> data;
  final List<Color> colorList;

  @override
  State<HomeChart> createState() => _HomeChartState();
}

class _HomeChartState extends State<HomeChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData(
        sections: _createHomeChart(widget.data, widget.colorList, touchedIndex),
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        )));
  }
}

List<PieChartSectionData> _createHomeChart(
    List<dynamic> data, colorList, int touchedIndex) {
  List<PieChartSectionData> result = List.generate(data.length, (index) {
    return PieChartSectionData(
      value: data[index]['categoryTotalAmount'].abs().toDouble(),
      color: colorList[index],
      title: data[index]['categoryName'],
      showTitle: index == touchedIndex ? true : false,
      titleStyle:
          const TextStyle(color: Colors.white, backgroundColor: Colors.black38),
      radius: 60,
    );
  });

  return result;
}
