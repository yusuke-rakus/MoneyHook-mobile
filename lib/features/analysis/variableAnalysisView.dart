import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:money_hooks/features/analysis/class/monthlyVariableData.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/appBarMonth.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/dataNotRegisteredBox.dart';
import 'package:money_hooks/features/analysis/data/analysisTransactionApi.dart';
import 'package:money_hooks/features/analysis/data/analysisTransactionLoad.dart';
import 'package:money_hooks/features/editTransaction/editTransaction.dart';

class VariableAnalysisView extends StatefulWidget {
  const VariableAnalysisView(this.env, this.isLoading, {super.key});

  final bool isLoading;
  final EnvClass env;

  @override
  State<VariableAnalysisView> createState() => _VariableAnalysis();
}

class _VariableAnalysis extends State<VariableAnalysisView> {
  late MonthlyVariableData data = MonthlyVariableData();
  late EnvClass env;
  late bool _isLoading;

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  void setMonthlyVariable(
      int totalVariable, List<MVCategoryClass> monthlyVariableList) {
    setState(() {
      data.totalVariable = totalVariable;
      data.monthlyVariableList = monthlyVariableList;
    });
  }

  void setReload() async {
    await AnalysisTransactionApi.getMonthlyVariableData(
        env, setLoading, setSnackBar, setMonthlyVariable);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
    env = widget.env;
    // env.initMonth();
    AnalysisTransactionLoad.getMonthlyVariableData(
        env, setLoading, setSnackBar, setMonthlyVariable);
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
            child: AppBarMonth(
              titleFontSize: 18,
              subtractMonth: () {
                setState(() {
                  env.subtractMonth();
                  AnalysisTransactionLoad.getMonthlyVariableData(
                      env, setLoading, setSnackBar, setMonthlyVariable);
                });
              },
              addMonth: () {
                env.addMonth();
                AnalysisTransactionLoad.getMonthlyVariableData(
                    env, setLoading, setSnackBar, setMonthlyVariable);
              },
              env: env,
            ),
          ),
          _isLoading
              ? Center(child: CommonLoadingAnimation.build())
              : Flexible(
                  child: ListView(
                  children: [
                    // 合計値
                    CenterWidget(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('変動費合計', style: TextStyle(fontSize: 17)),
                            const SizedBox(width: 10),
                            Text(TransactionClass.formatNum(data.totalVariable),
                                style: TextStyle(fontSize: 30)),
                            const SizedBox(width: 5),
                            const Text('円', style: TextStyle(fontSize: 17)),
                          ],
                        ),
                      ),
                    ),
                    // 変動費
                    data.monthlyVariableList.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            itemCount: data.monthlyVariableList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _variableAccordion(
                                  context, data.monthlyVariableList[index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return CenterWidget(
                                child: const Divider(),
                              );
                            },
                          )
                        : const DataNotRegisteredBox(message: '取引履歴が存在しません'),

                    const SizedBox(
                      height: 100,
                    )
                  ],
                )),
        ],
      ),
    );
  }

  // アコーディオン
  Widget _variableAccordion(
      BuildContext context, MVCategoryClass monthlyVariableList) {
    return CenterWidget(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(monthlyVariableList.categoryName),
                Text(
                    '¥${TransactionClass.formatNum(monthlyVariableList.categoryTotalAmount.abs())}'),
              ],
            ),
            textColor: Colors.black,
            children: monthlyVariableList.subCategoryList
                .map<Widget>((subCategory) => Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(subCategory.subCategoryName),
                            Text(
                                '¥${TransactionClass.formatNum(subCategory.subCategoryTotalAmount.abs())}'),
                          ],
                        ),
                        textColor: Colors.black,
                        children: subCategory.transactionList
                            .map<Widget>((tran) => ListTile(
                                    title: InkWell(
                                  onTap: () {
                                    TransactionClass transaction =
                                        TransactionClass.setTimelineFields(
                                            tran.transactionId,
                                            tran.transactionDate,
                                            tran.transactionSign,
                                            tran.transactionAmount.abs(),
                                            tran.transactionName,
                                            monthlyVariableList.categoryId,
                                            monthlyVariableList.categoryName,
                                            subCategory.subCategoryId,
                                            subCategory.subCategoryName,
                                            tran.fixedFlg,
                                            tran.paymentId,
                                            tran.paymentName);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditTransaction(
                                              transaction, env, setReload),
                                          fullscreenDialog: true),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${DateFormat('yyyy-MM-dd').parse(tran.transactionDate).day}日',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          tran.transactionName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            const Expanded(child: SizedBox()),
                                            Text(
                                                '¥${TransactionClass.formatNum(tran.transactionAmount.abs().toInt())}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )))
                            .toList(),
                      ),
                    ))
                .toList()),
      ),
    );
  }
}
