import "package:flutter/material.dart";
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/monthlyFixedData.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../components/fixedAnalysisAccordion.dart';

class FixedAnalysisView extends StatefulWidget {
  FixedAnalysisView(this.env, {super.key});

  envClass env;

  @override
  State<FixedAnalysisView> createState() => _FixedAnalysis();
}

class _FixedAnalysis extends State<FixedAnalysisView> {
  late monthlyFixedData monthlyFixedIncome = monthlyFixedData();
  late monthlyFixedData monthlyFixedSpending = monthlyFixedData();
  late envClass env;
  late bool _isLoading;

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void setMonthlyFixedIncome(
      int disposableIncome, List<dynamic> monthlyFixedList) {
    setState(() {
      monthlyFixedIncome.disposableIncome = disposableIncome;
      monthlyFixedIncome.monthlyFixedList = monthlyFixedList;
    });
  }

  void setMonthlyFixedSpending(
      int disposableIncome, List<dynamic> monthlyFixedList) {
    setState(() {
      monthlyFixedSpending.disposableIncome = disposableIncome;
      monthlyFixedSpending.monthlyFixedList = monthlyFixedList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    env.initMonth();
    transactionApi.getMonthlyFixedIncome(env, setMonthlyFixedIncome);
    transactionApi.getMonthlyFixedSpending(env, setMonthlyFixedSpending);
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
                        transactionApi.getMonthlyFixedIncome(
                            env, setMonthlyFixedIncome);
                        transactionApi.getMonthlyFixedSpending(
                            env, setMonthlyFixedSpending);
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Text('${env.getMonth()}月',
                    style: const TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        env.addMonth();
                        transactionApi.getMonthlyFixedIncome(
                            env, setMonthlyFixedIncome);
                        transactionApi.getMonthlyFixedSpending(
                            env, setMonthlyFixedSpending);
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
                    const Text('可処分所得額', style: TextStyle(fontSize: 17)),
                    const SizedBox(width: 20),
                    Text(
                        (monthlyFixedIncome.disposableIncome +
                                monthlyFixedSpending.disposableIncome)
                            .toString(),
                        style: const TextStyle(fontSize: 30)),
                  ],
                ),
              ),
              // 収入
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    color: Colors.white,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '収入',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          monthlyFixedIncome.disposableIncome.toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: FixedAnalysisAccordion(
                        monthlyFixedList: monthlyFixedIncome.monthlyFixedList),
                  )
                ],
              ),
              const SizedBox(height: 30),
              // 支出
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    color: Colors.white,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '支出',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          monthlyFixedSpending.disposableIncome.toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  FixedAnalysisAccordion(
                      monthlyFixedList: monthlyFixedSpending.monthlyFixedList),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
