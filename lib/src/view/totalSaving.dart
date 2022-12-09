import "package:flutter/material.dart";
import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/components/charts/totalSavingChart.dart';
import 'package:money_hooks/src/components/savingTargetList.dart';
import 'package:money_hooks/src/env/env.dart';

class TotalSaving extends StatefulWidget {
  const TotalSaving({super.key});

  @override
  State<TotalSaving> createState() => _TotalSaving();
}

class _TotalSaving extends State<TotalSaving> {
  late envClass env;
  late bool _isLoading;
  late List<savingTargetClass> savingTargetList = [];
  late int totalSaving = 0;
  late List<savingTargetClass> totalSavingChart = [];

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void setSavingTargetList(List<savingTargetClass> resultList) {
    setState(() {
      savingTargetList = resultList;
    });
  }

  void setTotalSaving(int resultAmount, List<savingTargetClass> resultList) {
    totalSaving = resultAmount;
    totalSavingChart = resultList;
  }

  @override
  void initState() {
    super.initState();
    env = envClass();
    savingApi.getSavingAmountForTarget(setSavingTargetList);
    // savingApi.getTotalSaving(env, setTotalSaving);
    totalSavingChart = [
      savingTargetClass.setChartFields(60000, DateTime(2022, 12, 1)),
      savingTargetClass.setChartFields(50000, DateTime(2022, 11, 1)),
      savingTargetClass.setChartFields(35000, DateTime(2022, 10, 1)),
      savingTargetClass.setChartFields(30000, DateTime(2022, 9, 1)),
      savingTargetClass.setChartFields(20000, DateTime(2022, 8, 1)),
      savingTargetClass.setChartFields(10000, DateTime(2022, 7, 1)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        // 合計値
        Container(
          margin: const EdgeInsets.only(right: 15, left: 15),
          height: 60,
          child: Row(
            children: [
              const Text('貯金総額', style: TextStyle(fontSize: 17)),
              const SizedBox(width: 20),
              Text(totalSaving.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.green)),
            ],
          ),
        ),
        // グラフ
        SizedBox(
          height: 200,
          child: TotalSavingChart(totalSavingChart),
        ),
        // 貯金目標リスト
        SavingTargetList(env: env, savingTargetList: savingTargetList),
        const SizedBox(
          height: 100,
        )
      ],
    ));
  }
}
