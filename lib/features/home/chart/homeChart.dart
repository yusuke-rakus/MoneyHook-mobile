import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/features/home/class/homeTransaction.dart';

class HomeChart extends StatefulWidget {
  const HomeChart({super.key, required this.data, required this.colorList});

  final HomeTransaction data;
  final List<Color> colorList;

  @override
  State<HomeChart> createState() => _HomeChartState();
}

class _HomeChartState extends State<HomeChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.categoryList.isNotEmpty) {
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
    HomeTransaction data, colorList, int touchedIndex) {
  List<PieChartSectionData> result =
      List.generate(data.categoryList.length, (index) {
    // 支出合計に占める割合が10%を超えていたらタイトルを表示する
    num spendSum = data.balance.abs();
    num value = data.categoryList[index]['category_total_amount'].abs();
    bool showTitle =
        value / spendSum * 100 > 10 || index == touchedIndex ? true : false;

    return PieChartSectionData(
      value: data.categoryList[index]['category_total_amount'].abs().toDouble(),
      color: colorList[index],
      title: data.categoryList[index]['category_name'],
      showTitle: showTitle,
      titleStyle: TextStyle(
          color: Colors.white,
          shadows: <Shadow>[Shadow(blurRadius: 5.0, color: Colors.black)]),
      radius: index == touchedIndex ? 70.0 : 60.0,
    );
  });

  return result;
}
