import 'package:flutter/material.dart';
import 'package:money_hooks/common/class/monthlyTransactionClass.dart';
import 'package:money_hooks/common/data/data/monthlyTransaction/commonMonthlyTransactionApi.dart';
import 'package:money_hooks/common/data/data/monthlyTransaction/commonMonthlyTransactionLoad.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/customFloatingActionButtonLocation.dart';
import 'package:money_hooks/common/widgets/dataNotRegisteredBox.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/features/settings/modals/editMonthlyTransaction.dart';

class MonthlyTransaction extends StatefulWidget {
  const MonthlyTransaction({super.key, required this.env});

  final EnvClass env;

  @override
  State<MonthlyTransaction> createState() => _MonthlyTransactionState();
}

class _MonthlyTransactionState extends State<MonthlyTransaction> {
  late EnvClass env;
  late List<MonthlyTransactionClass> monthlyTransactionList = [];
  late bool _isLoading;

  void setMonthlyTransactionList(List<MonthlyTransactionClass> resultList) {
    setState(() {
      monthlyTransactionList = resultList;
    });
  }

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = true;
    CommonMonthlyTransactionLoad.getFixed(
        env, setMonthlyTransactionList, setLoading, setSnackBar);
  }

  void setReload() {
    setLoading();
    CommonMonthlyTransactionApi.getFixed(
        env, setMonthlyTransactionList, setLoading, setSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientBar(),
        title: (const Text('設定')),
      ),
      body: _isLoading
          ? Center(child: CommonLoadingAnimation.build())
          : monthlyTransactionList.isNotEmpty
              ? ListView(
                  children: [
                    CenterWidget(
                        padding: const EdgeInsets.only(left: 10, bottom: 20),
                        height: 55,
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              '収支の自動入力',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                    ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: monthlyTransactionList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CenterWidget(
                            child: InkWell(
                              onTap: () {
                                // 収支の編集画面へ遷移
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditMonthlyTransaction(
                                                monthlyTransactionList[index],
                                                env,
                                                setReload,
                                                setSnackBar),
                                        fullscreenDialog: true));
                              },
                              child: _monthlyTransactionData(
                                  monthlyTransactionList[index]),
                            ),
                          );
                        }),
                  ],
                )
              : const DataNotRegisteredBox(message: '自動入力データが存在しません'),
      floatingActionButton: Tooltip(
        message: "毎月の自動入力を追加",
        child: FloatingActionButton(
          onPressed: () {
            // 収支の編集画面へ遷移
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditMonthlyTransaction(
                        MonthlyTransactionClass(), env, setReload, setSnackBar),
                    fullscreenDialog: true));
          },
          child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  colors: [Colors.lightBlueAccent, Colors.blueAccent],
                ),
              ),
              child: const Icon(Icons.add)),
        ),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
    );
  }

  // 月次固定費コンポーネント
  Widget _monthlyTransactionData(MonthlyTransactionClass monthlyTransaction) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 60,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                enabled: false,
                controller: TextEditingController(
                    text: monthlyTransaction.monthlyTransactionDate.toString()),
                decoration: const InputDecoration(
                  labelText: '振替日',
                  suffix: Text('日'),
                ),
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextField(
                enabled: false,
                controller: TextEditingController(
                    text: monthlyTransaction.monthlyTransactionName),
                decoration: const InputDecoration(
                  labelText: '取引名',
                ),
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 30,
              child: monthlyTransaction.monthlyTransactionSign > 0
                  ? const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextField(
                enabled: false,
                controller: TextEditingController(
                    text: MonthlyTransactionClass.formatNum(
                        monthlyTransaction.monthlyTransactionAmount.toInt())),
                decoration: const InputDecoration(
                  labelText: '金額',
                  suffix: Text('円'),
                ),
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ));
  }
}
