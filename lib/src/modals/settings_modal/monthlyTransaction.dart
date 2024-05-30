import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/monthlyTransactionApi.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/dataLoader/monthlyTransactionLoad.dart';
import 'package:money_hooks/src/modals/settings_modal/editMonthlyTransaction.dart';

import '../../class/monthlyTransactionClass.dart';
import '../../components/commonSnackBar.dart';
import '../../components/gradientBar.dart';
import '../../env/envClass.dart';

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
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CommonLoadingAnimation.build())
              : Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10, bottom: 20),
                        height: 55,
                        child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              '収支の自動入力',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: monthlyTransactionList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
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
                            );
                          }),
                    ),
                  ],
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                style: const TextStyle(fontSize: 17),
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
                style: const TextStyle(fontSize: 15),
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
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ],
        ));
  }
}
