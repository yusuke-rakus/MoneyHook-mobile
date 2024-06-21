import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/homeTransaction.dart';
import 'package:money_hooks/src/components/homeAccordion.dart';
import 'package:money_hooks/src/dataLoader/transactionLoad.dart';

import '../class/transactionClass.dart';
import '../components/centerWidget.dart';
import '../components/charts/homeChart.dart';
import '../components/commonLoadingAnimation.dart';
import '../components/commonSnackBar.dart';
import '../components/gradientBar.dart';
import '../env/envClass.dart';
import '../modals/editTransaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final envClass env;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late envClass env;
  late HomeTransaction homeTransactionList = HomeTransaction();
  late bool _isLoading;
  static const List<Color> colorList = [
    Colors.redAccent,
    Colors.lightBlue,
    Colors.greenAccent,
    Colors.indigo,
    Colors.amber,
    Colors.teal,
    Colors.deepPurpleAccent,
    Colors.grey
  ];

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

  void setHomeTransaction(int balance, List<dynamic> responseList) {
    setState(() {
      homeTransactionList.balance = balance;
      homeTransactionList.categoryList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    env.initMonth();
    _isLoading = widget.isLoading;
    TransactionLoad.getHome(env, setLoading, setSnackBar, setHomeTransaction);
  }

  void setReload() {
    transactionApi.getHome(env, setLoading, setSnackBar, setHomeTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientBar(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Tooltip(
              message: "前の月",
              child: IconButton(
                  onPressed: () {
                    env.subtractMonth();
                    TransactionLoad.getHome(
                        env, setLoading, setSnackBar, setHomeTransaction);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
            ),
            Text('${env.getMonth()}月'),
            Tooltip(
              message: "次の月",
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      // 翌月が未来でなければデータ取得
                      if (env.isNotCurrentMonth()) {
                        env.addMonth();
                        TransactionLoad.getHome(
                            env, setLoading, setSnackBar, setHomeTransaction);
                      }
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios)),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CommonLoadingAnimation.build())
          : ListView(
              children: [
                // 円グラフ
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 250,
                    child: HomeChart(
                        data: homeTransactionList.categoryList,
                        colorList: colorList),
                  ),
                ),
                // 収支
                CenterWidget(
                  height: 40,
                  margin: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      const Text('支出合計', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 20),
                      Text(
                          TransactionClass.formatNum(
                              homeTransactionList.balance),
                          style: TextStyle(
                              fontSize: 20,
                              color: homeTransactionList.balance < 0
                                  ? Colors.red
                                  : Colors.green)),
                    ],
                  ),
                ),
                // アコーディオン
                CenterWidget(
                  child: HomeAccordion(
                      homeTransactionList: homeTransactionList.categoryList,
                      colorList: colorList),
                ),
                const SizedBox(
                  height: 90,
                )
              ],
            ),
      floatingActionButton: Tooltip(
        message: "収支を追加",
        child: FloatingActionButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditTransaction(TransactionClass(), env, setReload),
                        fullscreenDialog: true),
                  );
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
    );
  }
}
