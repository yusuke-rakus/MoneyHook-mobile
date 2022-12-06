import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/homeTransaction.dart';
import 'package:money_hooks/src/components/charts/homeChart.dart';
import 'package:money_hooks/src/components/homeAccordion.dart';

import '../class/transactionClass.dart';
import '../env/env.dart';
import '../modals/editTransaction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late envClass env;
  late homeTransaction homeTransactionList;
  bool _isLoading = false;

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    env = envClass();
    homeTransactionList = homeTransaction(100000, [
      {
        'categoryName': '食費',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '-10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '-10000',
          },
        ]
      },
      {
        'categoryName': '食費',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '-10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '-10000',
          },
        ]
      },
      {
        'categoryName': '食費',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '-10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '-10000',
          },
        ]
      },
    ]);
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
                  setState(() {
                    env.subtractMonth();
                    transactionApi.getHome(env, setLoading);
                  });
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text('${env.getMonth()}月'),
            IconButton(
                onPressed: () {
                  setState(() {
                    env.addMonth();
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : ListView(
              children: [
                // 円グラフ
                const Center(
                  child: SizedBox(
                    height: 250,
                    child: HomeChart(),
                  ),
                ),
                // 収支
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 40,
                  child: Row(
                    children: const [
                      Text('収支', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 20),
                      Text('-12000',
                          style: TextStyle(fontSize: 20, color: Colors.red)),
                    ],
                  ),
                ),
                // アコーディオン
                HomeAccordion(
                  homeTransactionList: homeTransactionList.categoryList,
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditTransaction(transactionClass()),
                fullscreenDialog: true),
          );
        },
      ),
    );
  }
}
