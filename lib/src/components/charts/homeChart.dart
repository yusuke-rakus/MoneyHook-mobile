import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeChart extends StatefulWidget {
  const HomeChart({super.key, required this.data, required this.colorList});

  final List<dynamic> data;
  final List<Color> colorList;

  @override
  State<HomeChart> createState() => _HomeChartState();
}

class _HomeChartState extends State<HomeChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return PieChart(PieChartData(
          startDegreeOffset: 270.0,
          centerSpaceColor: Colors.transparent,
          sections:
              _createHomeChart(widget.data, widget.colorList, touchedIndex),
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
    } else {
      return const SizedBox();
    }
  }
}

List<PieChartSectionData> _createHomeChart(
    List<dynamic> data, colorList, int touchedIndex) {
  List<PieChartSectionData> result = List.generate(data.length, (index) {
    return PieChartSectionData(
      value: data[index]['category_total_amount'].abs().toDouble(),
      color: colorList[index],
      title: data[index]['category_name'],
      showTitle: index == touchedIndex ? true : false,
      titleStyle:
          const TextStyle(color: Colors.white, backgroundColor: Colors.black38),
      radius: 60,
    );
  });

  return result;
}
