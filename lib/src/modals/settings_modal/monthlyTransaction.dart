import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/monthlyTransactionApi.dart';
import 'package:money_hooks/src/modals/settings_modal/editMonthlyTransaction.dart';

import '../../class/monthlyTransactionClass.dart';
import '../../env/envClass.dart';

class MonthlyTransaction extends StatefulWidget {
  MonthlyTransaction({Key? key, required this.env}) : super(key: key);
  envClass env;

  @override
  State<MonthlyTransaction> createState() => _MonthlyTransactionState();
}

class _MonthlyTransactionState extends State<MonthlyTransaction> {
  late envClass env;
  late List<monthlyTransactionClass> monthlyTransactionList = [];

  void setMonthlyTransactionList(List<monthlyTransactionClass> resultList) {
    setState(() {
      monthlyTransactionList = resultList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    monthlyTransactionApi.getFixed(env, setMonthlyTransactionList);
  }

  void setReload() {
    // transactionApi.getHome(env, setLoading, setHomeTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('設定')),
      ),
      body: ListView(
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
          ListView.builder(
              shrinkWrap: true,
              itemCount: monthlyTransactionList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    print(monthlyTransactionList[index].monthlyTransactionId);
                    // TODO 個別編集
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditMonthlyTransaction(
                                monthlyTransactionList[index], env, setReload),
                            fullscreenDialog: true));
                  },
                  child: _monthlyTransactionData(monthlyTransactionList[index]),
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO 新規追加
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditMonthlyTransaction(
                      monthlyTransactionClass(), env, setReload),
                  fullscreenDialog: true));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // 月次固定費コンポーネント
  Widget _monthlyTransactionData(monthlyTransactionClass monthlyTransaction) {
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
                    text: monthlyTransactionClass.formatNum(
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
