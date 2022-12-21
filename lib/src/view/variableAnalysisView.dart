import "package:flutter/material.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../class/response/monthlyVariableData.dart';

class VariableAnalysisView extends StatefulWidget {
  VariableAnalysisView(this.env, this.isLoading, {super.key});

  bool isLoading;
  envClass env;

  @override
  State<VariableAnalysisView> createState() => _VariableAnalysis();
}

class _VariableAnalysis extends State<VariableAnalysisView> {
  late monthlyVariableData data = monthlyVariableData();
  late envClass env;
  late bool _isLoading;

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void setMonthlyVariable(
      int totalVariable, List<dynamic> monthlyVariableList) {
    setState(() {
      data.totalVariable = totalVariable;
      data.monthlyVariableList = monthlyVariableList;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
    env = widget.env;
    env.initMonth();
    transactionApi.getMonthlyVariableData(env, setLoading, setMonthlyVariable);
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
                        transactionApi.getMonthlyVariableData(
                            env, setLoading, setMonthlyVariable);
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
                          transactionApi.getMonthlyVariableData(
                              env, setLoading, setMonthlyVariable);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: const Color(0xFF76D5FF), size: 50))
              : Flexible(
                  child: ListView(
                  children: [
                    // 合計値
                    Container(
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      height: 60,
                      child: Row(
                        children: [
                          const Text('変動費合計', style: TextStyle(fontSize: 17)),
                          const SizedBox(width: 20),
                          Text(transactionClass.formatNum(data.totalVariable),
                              style: const TextStyle(fontSize: 30)),
                        ],
                      ),
                    ),
                    // 変動費
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      itemCount: data.monthlyVariableList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _variableAccordion(
                            context, data.monthlyVariableList[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  ],
                )),
        ],
      ),
    );
  }

  // アコーディオン
  Widget _variableAccordion(
      BuildContext context, Map<String, dynamic> monthlyVariableList) {
    return ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${monthlyVariableList['categoryName']}'),
            Text(transactionClass
                .formatNum(monthlyVariableList['categoryTotalAmount'].abs())),
          ],
        ),
        children: monthlyVariableList['subCategoryList']
            .map<Widget>((subCategory) => ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subCategory['subCategoryName']),
                      Text(transactionClass.formatNum(
                          subCategory['subCategoryTotalAmount'].abs())),
                    ],
                  ),
                  children: subCategory['transactionList']
                      .map<Widget>((tran) => ListTile(
                              title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tran['transactionName']),
                              Text(transactionClass
                                  .formatNum(tran['transactionAmount'].abs())),
                            ],
                          )))
                      .toList(),
                ))
            .toList());
  }
}
