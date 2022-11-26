import "package:flutter/material.dart";
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/components/savingTargetList.dart';
import 'package:money_hooks/src/env/env.dart';

class TotalSaving extends StatefulWidget {
  const TotalSaving({super.key});

  @override
  State<TotalSaving> createState() => _TotalSaving();
}

class _TotalSaving extends State<TotalSaving> {
  late envClass env;
  late List<savingTargetClass> savingTargetList;

  @override
  void initState() {
    super.initState();
    env = envClass();
    savingTargetList = [
      savingTargetClass.setFields('1', '1', '目標サンプル1', '100000'),
      savingTargetClass.setFields('1', '1', '目標サンプル2', '100000'),
      savingTargetClass.setFields('1', '1', '目標サンプル3', '100000')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
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
                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              const Text('11月', style: TextStyle(fontSize: 15)),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_forward_ios)),
            ],
          ),
        ),
        // 合計値
        Container(
          margin: const EdgeInsets.only(right: 15, left: 15),
          height: 60,
          child: Row(
            children: const [
              Text('変動費合計', style: TextStyle(fontSize: 17)),
              SizedBox(width: 20),
              Text('11,111',
                  style: TextStyle(fontSize: 20, color: Colors.green)),
            ],
          ),
        ),
        // グラフ
        Container(
          height: 150,
          margin: const EdgeInsets.all(20),
          color: Colors.blueGrey,
          child: const Center(child: Text('グラフだよ')),
        ),
        // 貯金目標リスト
        SavingTargetList(env: env, savingTargetList: savingTargetList),
      ],
    ));
  }
}
