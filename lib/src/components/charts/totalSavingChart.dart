import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/transactionClass.dart';

import '../../class/savingTargetClass.dart';

class TotalSavingChart extends StatelessWidget {
  TotalSavingChart(this.data, {super.key});

  List<savingTargetClass> data;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        lineBarsData: _createTotalSavingData(data),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles()),
          topTitles: const AxisTitles(sideTitles: SideTitles()),
          rightTitles: const AxisTitles(sideTitles: SideTitles()),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 0,
                      child: Text(
                          '${data[value.toInt()].savingMonth.month.toString()}月'),
                    );
                  })),
        ),
        lineTouchData: lineTouchData,
      ),
    );
  }

  LineTouchData get lineTouchData => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                    '¥${transactionClass.formatNum(barSpot.y.toInt())}',
                    const TextStyle(color: Colors.white));
              }).toList();
            }),
      );

  List<LineChartBarData> _createTotalSavingData(List<savingTargetClass> data) {
    List<LineChartBarData> result = [
      LineChartBarData(
          spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(),
                  data[index].monthlyTotalSavingAmount.toDouble())),
          gradient: const LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent]),
          dotData: const FlDotData(show: false))
    ];

    return result;
  }
}
