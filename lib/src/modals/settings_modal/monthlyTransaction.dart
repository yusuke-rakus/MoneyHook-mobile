import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/monthlyTransactionApi.dart';
import 'package:money_hooks/src/class/monthlyTransactionClass.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/components/customFloatingActionButtonLocation.dart';
import 'package:money_hooks/src/components/customFloatingButtonLocation.dart';
import 'package:money_hooks/src/components/dataNotRegisteredBox.dart';
import 'package:money_hooks/src/components/gradientBar.dart';
import 'package:money_hooks/src/dataLoader/monthlyTransactionLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/settings_modal/editMonthlyTransaction.dart';

class MonthlyTransaction extends StatefulWidget {
  const MonthlyTransaction({Key? key, required this.env}) : super(key: key);
  final envClass env;

  @override
  State<MonthlyTransaction> createState() => _MonthlyTransactionState();
}

class _MonthlyTransactionState extends State<MonthlyTransaction> {
  late envClass env;
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
    MonthlyTransactionLoad.getFixed(
        env, setMonthlyTransactionList, setLoading, setSnackBar);
  }

  void setReload() {
    setLoading();
    MonthlyTransactionApi.getFixed(
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
                        child: const Align(
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
              : const dataNotRegisteredBox(message: '自動入力データが存在しません'),
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
