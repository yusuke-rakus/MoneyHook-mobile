import "package:flutter/material.dart";
import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/components/charts/totalSavingChart.dart';
import 'package:money_hooks/src/dataLoader/savingLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../components/commonLoadingAnimation.dart';
import '../components/commonSnackBar.dart';
import '../components/dataNotRegisteredBox.dart';
import '../components/savingTargetList.dart';

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

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
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

  void setReload() async {
    setLoading();
    await SavingApi.getSavingAmountForTarget(
        env.userId, setSnackBar, setSavingTargetList);
    await SavingApi.getTotalSaving(env, setTotalSaving);
    setLoading();
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = widget.isLoading;
    setLoading();
    env.initMonth();
    Future(() async {
      await SavingLoad.getTotalSaving(env, setTotalSaving);
      await SavingLoad.getSavingAmountForTarget(
          env.userId, setSnackBar, setSavingTargetList);
      setLoading();
    });
    widget.changeReload(setReload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(child: CommonLoadingAnimation.build())
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(left: 30, right: 30),
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
