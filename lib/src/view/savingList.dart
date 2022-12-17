import "package:flutter/material.dart";
import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/components/savingTimelineList.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../class/savingClass.dart';

class SavingList extends StatefulWidget {
  SavingList(this.env, {super.key});

  envClass env;

  @override
  State<SavingList> createState() => _SavingList();
}

class _SavingList extends State<SavingList> {
  late List<savingClass> savingList = [];
  late var totalSavingAmount = 0;
  late envClass env;
  late bool _isLoading;

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void setSavingList(List<savingClass> resultList, var resultAmount) {
    setState(() {
      savingList = resultList;
      totalSavingAmount = resultAmount;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    env.initMonth();
    savingApi.getMonthlySavingData(env, setSavingList);
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
                        savingApi.getMonthlySavingData(env, setSavingList);
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Text('${env.getMonth()}月',
                    style: const TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        env.addMonth();
                        savingApi.getMonthlySavingData(env, setSavingList);
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          Flexible(
            child: ListView(children: [
              // 合計値
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15),
                height: 60,
                child: Row(
                  children: [
                    const Text('今月の貯金', style: TextStyle(fontSize: 17)),
                    const SizedBox(width: 20),
                    Text(totalSavingAmount.toString(),
                        style:
                            const TextStyle(fontSize: 30, color: Colors.green)),
                  ],
                ),
              ),
              // タイムライン
              SavingTimelineList(
                env: env,
                savingTimelineList: savingList,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
