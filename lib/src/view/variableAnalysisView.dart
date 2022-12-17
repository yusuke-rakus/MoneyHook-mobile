import "package:flutter/material.dart";
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../class/response/monthlyVariableData.dart';

class VariableAnalysisView extends StatefulWidget {
  VariableAnalysisView(this.env, {super.key});

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
    env = widget.env;
    env.initMonth();
    transactionApi.getMonthlyVariableData(env, setMonthlyVariable);
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
                            env, setMonthlyVariable);
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Text('${env.getMonth()}月',
                    style: const TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        env.addMonth();
                        transactionApi.getMonthlyVariableData(
                            env, setMonthlyVariable);
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          Flexible(
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
                    Text(data.totalVariable.toString(),
                        style: const TextStyle(fontSize: 30)),
                  ],
                ),
              ),
              // 変動費
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
            Text(monthlyVariableList['categoryTotalAmount'].abs().toString()),
          ],
        ),
        children: monthlyVariableList['subCategoryList']
            .map<Widget>((subCategory) => ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subCategory['subCategoryName']),
                      Text(subCategory['subCategoryTotalAmount']
                          .abs()
                          .toString()),
                    ],
                  ),
                  children: subCategory['transactionList']
                      .map<Widget>((tran) => ListTile(
                              title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(tran['transactionName']),
                              Text(tran['transactionAmount'].abs().toString()),
                            ],
                          )))
                      .toList(),
                ))
            .toList());
  }
}
