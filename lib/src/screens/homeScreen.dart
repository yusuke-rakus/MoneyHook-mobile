import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/homeTransaction.dart';
import 'package:money_hooks/src/components/charts/homeChart.dart';
import 'package:money_hooks/src/components/homeAccordion.dart';

import '../class/transactionClass.dart';
import '../env/envClass.dart';
import '../modals/editTransaction.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.isLoading, this.env, {super.key});

  bool isLoading;
  envClass env;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late envClass env;
  late homeTransaction homeTransactionList = homeTransaction();
  late bool _isLoading;
  FlutterSecureStorage storage = const FlutterSecureStorage();

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
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
    transactionApi.getHome(env, setLoading, setHomeTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  env.subtractMonth();
                  transactionApi.getHome(env, setLoading, setHomeTransaction);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text('${env.getMonth()}月'),
            IconButton(
                onPressed: () {
                  setState(() {
                    // 翌月が未来でなければデータ取得
                    if (env.isNotCurrentMonth()) {
                      env.addMonth();
                      transactionApi.getHome(
                          env, setLoading, setHomeTransaction);
                    }
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: const Color(0xFF76D5FF), size: 50))
          : ListView(
              children: [
                // 円グラフ
                Center(
                  child: SizedBox(
                    height: 250,
                    child: HomeChart(homeTransactionList.categoryList),
                  ),
                ),
                // 収支
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 40,
                  child: Row(
                    children: [
                      const Text('収支', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 20),
                      Text(homeTransactionList.balance.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: homeTransactionList.balance < 0
                                  ? Colors.red
                                  : Colors.green)),
                    ],
                  ),
                ),
                // アコーディオン
                HomeAccordion(
                  homeTransactionList: homeTransactionList.categoryList,
                ),
                const SizedBox(
                  height: 90,
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditTransaction(transactionClass(), env),
                      fullscreenDialog: true),
                );
              },
        child: const Icon(Icons.add),
      ),
    );
  }
}
