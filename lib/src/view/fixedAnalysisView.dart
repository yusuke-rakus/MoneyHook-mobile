import "package:flutter/material.dart";
import 'package:money_hooks/src/class/response/monthlyFixedData.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/components/dataNotRegisteredBox.dart';
import 'package:money_hooks/src/dataLoader/transactionLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../components/centerWidget.dart';
import '../components/customFloatingButtonLocation.dart';
import '../components/fixedAnalysisAccordion.dart';

class FixedAnalysisView extends StatefulWidget {
  const FixedAnalysisView(this.env, this.isLoading, {super.key});

  final bool isLoading;
  final envClass env;

  @override
  State<FixedAnalysisView> createState() => _FixedAnalysis();
}

class _FixedAnalysis extends State<FixedAnalysisView> {
  late MonthlyFixedData monthlyFixedIncome = MonthlyFixedData();
  late MonthlyFixedData monthlyFixedSpending = MonthlyFixedData();
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
    _isLoading = widget.isLoading;
    setLoading();
    env.initMonth();
    Future(() async {
      await TransactionLoad.getMonthlyFixedIncome(env, setMonthlyFixedIncome);
      await TransactionLoad.getMonthlyFixedSpending(
          env, setSnackBar, setMonthlyFixedSpending);
      setLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 月選択
          CenterWidget(
            margin: const EdgeInsets.only(right: 15, left: 15),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: "前の月",
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          env.subtractMonth();
                          setLoading();
                          Future(() async {
                            await TransactionLoad.getMonthlyFixedIncome(
                                env, setMonthlyFixedIncome);
                            await TransactionLoad.getMonthlyFixedSpending(
                                env, setSnackBar, setMonthlyFixedSpending);
                            setLoading();
                          });
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                ),
                Text('${env.getMonth()}月',
                    style: const TextStyle(fontSize: 18)),
                Tooltip(
                  message: "次の月",
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          // 翌月が未来でなければデータ取得
                          if (env.isNotCurrentMonth()) {
                            env.addMonth();
                            setLoading();
                            Future(() async {
                              await TransactionLoad.getMonthlyFixedIncome(
                                  env, setMonthlyFixedIncome);
                              await TransactionLoad.getMonthlyFixedSpending(
                                  env, setSnackBar, setMonthlyFixedSpending);
                              setLoading();
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.arrow_forward_ios)),
                ),
              ],
            ),
          ),
          _isLoading
              ? CommonLoadingAnimation.build()
              : Flexible(
                  child: monthlyFixedIncome.monthlyFixedList.isNotEmpty ||
                          monthlyFixedSpending.monthlyFixedList.isNotEmpty
                      ? ListView(
                          children: [
                            // 合計値
                            CenterWidget(
                              margin:
                                  const EdgeInsets.only(right: 15, left: 15),
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('可処分所得額',
                                      style: TextStyle(fontSize: 17)),
                                  const SizedBox(width: 20),
                                  Text(
                                      TransactionClass.formatNum(
                                          (monthlyFixedIncome.disposableIncome +
                                              monthlyFixedSpending
                                                  .disposableIncome)),
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: (monthlyFixedIncome
                                                          .disposableIncome +
                                                      monthlyFixedSpending
                                                          .disposableIncome) <
                                                  0
                                              ? const Color(0xFFB71C1C)
                                              : const Color(0xFF1B5E20))),
                                ],
                              ),
                            ),
                            // 収入
                            Column(
                              children: [
                                CenterWidget(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  color: Colors.white,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '収入',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        '¥${TransactionClass.formatNum(monthlyFixedIncome.disposableIncome)}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF1B5E20)),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: FixedAnalysisAccordion(
                                      monthlyFixedList:
                                          monthlyFixedIncome.monthlyFixedList),
                                )
                              ],
                            ),
                            const SizedBox(height: 30),
                            // 支出
                            Column(
                              children: [
                                CenterWidget(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  color: Colors.white,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '支出',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        '¥${TransactionClass.formatNum(monthlyFixedSpending.disposableIncome.abs())}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFFB71C1C)),
                                      )
                                    ],
                                  ),
                                ),
                                FixedAnalysisAccordion(
                                    monthlyFixedList:
                                        monthlyFixedSpending.monthlyFixedList),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ),
                          ],
                        )
                      : const dataNotRegisteredBox(message: '取引履歴が存在しません')),
        ],
      ),
    );
  }
}
