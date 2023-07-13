import "package:flutter/material.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/components/charts/totalSavingChart.dart';
import 'package:money_hooks/src/components/dataNotRegisteredBox.dart';
import 'package:money_hooks/src/components/savingTargetList.dart';
import 'package:money_hooks/src/env/envClass.dart';

class TotalSaving extends StatefulWidget {
  TotalSaving(this.env, this.isLoading, this.changeReload, {super.key});

  envClass env;
  bool isLoading;
  Function changeReload;

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
    setState(() {
      totalSaving = resultAmount;
      totalSavingChart = resultList;
    });
  }

  void setReload() {
    savingApi.getSavingAmountForTarget(
        env.userId, setLoading, setSavingTargetList);
    savingApi.getTotalSaving(env, setTotalSaving);
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = widget.isLoading;
    env.initMonth();
    savingApi.getSavingAmountForTarget(
        env.userId, setLoading, setSavingTargetList);
    savingApi.getTotalSaving(env, setTotalSaving);
    widget.changeReload(setReload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.waveDots(
                    color: const Color(0xFF76D5FF), size: 50))
            : ListView(
                children: [
                  // 合計値
                  Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
                    height: 60,
                    child: Row(
                      children: [
                        const Text('貯金総額', style: TextStyle(fontSize: 17)),
                        const SizedBox(width: 20),
                        Text(savingTargetClass.formatNum(totalSaving),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.green)),
                      ],
                    ),
                  ),

                  // グラフ
                  SizedBox(
                    height: 200,
                    child: TotalSavingChart(totalSavingChart),
                  ),
                  savingTargetList.isNotEmpty
                      ?
                      // 貯金目標リスト
                      SavingTargetList(
                          context: context,
                          env: env,
                          savingTargetList: savingTargetList,
                          setReload: setReload,
                        )
                      : const dataNotRegisteredBox(message: '貯金目標が存在しません'),
                ],
              ));
  }
}
