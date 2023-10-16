import "package:flutter/material.dart";
import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/components/dataNotRegisteredBox.dart';
import 'package:money_hooks/src/components/savingTimelineList.dart';
import 'package:money_hooks/src/dataLoader/savingLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../class/savingClass.dart';
import '../components/commonSnackBar.dart';

class SavingList extends StatefulWidget {
  const SavingList(this.env, this.isLoading, this.changeReload, {super.key});

  final envClass env;
  final bool isLoading;
  final Function changeReload;

  @override
  State<SavingList> createState() => _SavingList();
}

class _SavingList extends State<SavingList> {
  late List<SavingClass> savingList = [];
  late var totalSavingAmount = 0;
  late envClass env;
  late bool _isLoading;

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

  void setSavingList(List<SavingClass> resultList, var resultAmount) {
    setState(() {
      savingList = resultList;
      totalSavingAmount = resultAmount;
    });
  }

  void setReload() {
    SavingApi.getMonthlySavingData(env, setLoading, setSnackBar, setSavingList);
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = widget.isLoading;
    env.initMonth();
    SavingLoad.getMonthlySavingData(
        env, setLoading, setSnackBar, setSavingList);
    widget.changeReload(setReload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 月選択
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        env.subtractMonth();
                        SavingLoad.getMonthlySavingData(
                            env, setLoading, setSnackBar, setSavingList);
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Text('${env.getMonth()}月',
                    style: const TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        // 翌月が未来でなければデータ取得
                        if (env.isNotCurrentMonth()) {
                          env.addMonth();
                          SavingLoad.getMonthlySavingData(
                              env, setLoading, setSnackBar, setSavingList);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          _isLoading
              ? CommonLoadingAnimation.build()
              : Flexible(
                  child: RefreshIndicator(
                    color: Colors.grey,
                    onRefresh: () async {
                      SavingApi.getMonthlySavingData(
                          env, setLoading, setSnackBar, setSavingList);
                    },
                    child: ListView(children: [
                      // 合計値
                      Container(
                        margin: const EdgeInsets.only(right: 15, left: 15),
                        height: 60,
                        child: Row(
                          children: [
                            const Text('今月の貯金', style: TextStyle(fontSize: 17)),
                            const SizedBox(width: 20),
                            Text(SavingClass.formatNum(totalSavingAmount),
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.green)),
                          ],
                        ),
                      ),
                      savingList.isNotEmpty
                          ?
                          // タイムライン
                          SavingTimelineList(
                              env: env,
                              savingTimelineList: savingList,
                              setReload: setReload,
                            )
                          : const dataNotRegisteredBox(message: '貯金履歴が存在しません')
                    ]),
                  ),
                ),
        ],
      ),
    );
  }
}
