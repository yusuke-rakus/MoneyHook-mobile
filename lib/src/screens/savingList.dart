import "package:flutter/material.dart";
import 'package:money_hooks/src/components/savingTimelineList.dart';
import 'package:money_hooks/src/env/env.dart';

import '../class/savingClass.dart';

class SavingList extends StatefulWidget {
  const SavingList({super.key});

  @override
  State<SavingList> createState() => _SavingList();
}

class _SavingList extends State<SavingList> {
  late envClass env;
  late List<savingClass> savingList;

  @override
  void initState() {
    super.initState();
    env = envClass();
    savingList = [
      savingClass.setFields('1', '2022-11-11', '交通費', '1', '200', '1', '旅行'),
      savingClass.setFields('1', '2022-11-11', '交通費', '1', '200', '1', '旅行'),
      savingClass.setFields('1', '2022-11-11', '交通費', '1', '200', '1', '旅行')
    ];
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
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Text('${env.getMonth()}月',
                    style: const TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        env.addMonth();
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
                  children: const [
                    Text('変動費合計', style: TextStyle(fontSize: 17)),
                    SizedBox(width: 20),
                    Text('11,111',
                        style: TextStyle(fontSize: 30, color: Colors.green)),
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
