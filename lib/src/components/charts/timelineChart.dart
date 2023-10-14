import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../class/transactionClass.dart';

class TimelineChart extends StatefulWidget {
  TimelineChart(this.data, {super.key});

  List<transactionClass> data;

  @override
  State<TimelineChart> createState() => _TimelineChartState();
}

class _TimelineChartState extends State<TimelineChart> {
  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
          barGroups: _createTimelineChart(widget.data),
          titlesData: titlesData,
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: false,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.transparent,
              tooltipMargin: 0,
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  '¥${transactionClass.formatNum(rod.toY.toInt())}',
                  const TextStyle(color: Colors.blueGrey),
                );
              },
            ),
            touchCallback: (event, response) {
              if (event.isInterestedForInteractions &&
                  response != null &&
                  response.spot != null) {
                setState(() {
                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                });
              } else {
                setState(() {
                  touchedGroupIndex = -1;
                });
              }
            },
          )),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
    );
    String text = widget.data[value.toInt()].transactionDate;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles:
                SideTitles(showTitles: true, getTitlesWidget: getTitles)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      );

  List<BarChartGroupData> _createTimelineChart(List<transactionClass> data) {
    List<BarChartGroupData> result = List.generate(
        data.length,
        (index) => BarChartGroupData(
            x: index,
            groupVertically: true,
            barRods: [
              BarChartRodData(
                  toY: data[index].transactionAmount.toDouble(),
                  gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter))
            ],
            showingTooltipIndicators: touchedGroupIndex == index ? [0] : []));
    return result;
  }
}
