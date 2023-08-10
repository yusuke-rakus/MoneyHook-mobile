import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/searchTransactionData.dart';

import '../../class/transactionClass.dart';
import '../../components/commonSnackBar.dart';
import '../../env/envClass.dart';
import '../../searchStorage/categoryStorage.dart';
import '../selectCategory.dart';

class SearchTransaction extends StatefulWidget {
  SearchTransaction({Key? key, required this.env}) : super(key: key);
  envClass env;

  @override
  State<SearchTransaction> createState() => _SearchTransaction();
}

class _SearchTransaction extends State<SearchTransaction> {
  late envClass env;
  late bool _isLoading;
  late searchTransactionData resultData = searchTransactionData();
  transactionClass transaction = transactionClass();
  String searchTitle = '';

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  void setStartMonth(String value) {
    transaction.startMonth = value;
  }

  void setEndMonth(String value) {
    transaction.endMonth = value;
  }

  void _setDefaultCategory(transactionClass transaction) {
    CategoryStorage.getDefaultValue().then((category) {
      setState(() {
        transaction.categoryId = category.categoryId;
        transaction.categoryName = category.categoryName;
        transaction.subCategoryId = category.subCategoryId;
        transaction.subCategoryName = category.subCategoryName;
      });
    });
  }

  void setTransactionList(
      int totalSpending, List<Map<String, dynamic>> resultList) {
    setState(() {
      resultData.totalSpending = totalSpending;
      resultData.monthlyVariableList = resultList;
    });
  }

  void searchTransaction() {
    transactionApi.getTotalSpending(env, transaction, setTransactionList);
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = false;
    _setDefaultCategory(transaction);

    DateTime now = DateTime.now();
    transaction.startMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    transaction.endMonth = DateFormat('yyyy-MM-dd').format(
        DateTime(now.year, now.month + 1, 1).add(const Duration(days: -1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: (const Text('設定')),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              searchTitle,
              style: const TextStyle(fontSize: 20),
            ),
            textColor: Colors.black,
            initiallyExpanded: true,
            onExpansionChanged: (isOpen) {
              setState(() {
                if (isOpen) {
                  searchTitle = '';
                } else {
                  searchTitle =
                      '${transaction.categoryName} / ${transaction.subCategoryName}';
                }
              });
            },
            children: [
              // カテゴリタイトル
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '検索するカテゴリを選択',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
              // カテゴリ
              Container(
                  margin: const EdgeInsetsDirectional.only(
                      start: 30, end: 30, bottom: 30),
                  child: InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectCategory(env),
                          ),
                        );
                        if (result == null) return;
                        setState(() {
                          transaction.categoryName = result['categoryName'];
                          transaction.categoryId = result['categoryId'];
                          transaction.subCategoryName =
                              result['subCategoryName'];
                          transaction.subCategoryId = result['subCategoryId'];
                        });
                      },
                      child: SizedBox(
                          height: 70,
                          child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'カテゴリ',
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${transaction.categoryName} / ${transaction.subCategoryName}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 20),
                                    )),
                                    const Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 30,
                                        ))
                                  ]))))),
              // 期間タイトル
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '期間を選択',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
              dateSelectWidget(
                  context: context,
                  title: '開始日',
                  targetMonth: transaction.startMonth,
                  setFunction: setStartMonth),

              dateSelectWidget(
                context: context,
                title: '終了日',
                targetMonth: transaction.endMonth,
                setFunction: setEndMonth,
              ),
              // 検索ボタン
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                      child: Container(
                          color: Colors.white,
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                searchTransaction();
                              },
                              child: const Text(
                                '検索',
                                style:
                                    TextStyle(fontSize: 23, letterSpacing: 20),
                              )))))
            ],
          ),
        ));
  }

  // 日付選択ウィジェット
  Widget dateSelectWidget(
      {required BuildContext context,
      required String title,
      required String targetMonth,
      required Function setFunction}) {
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
            height: 250,
            color: Colors.white,
            child: CupertinoDatePicker(
              initialDateTime: DateFormat('yyyy-MM-dd').parse(targetMonth),
              onDateTimeChanged: (value) {
                setState(() {
                  setFunction(DateFormat('yyyy-MM-dd').format(value));
                });
              },
              // minimumYear: DateTime.now().year - 1,
              // maximumYear: DateTime.now().year,
              // maximumDate: DateTime.now(),
              dateOrder: DatePickerDateOrder.ymd,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        );
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '${targetMonth.replaceAll('-', '月').replaceFirst('月', '年')}日',
                    style: const TextStyle(fontSize: 20)),
                const Icon(Icons.edit),
              ],
            )
          ],
        ),
      ),
    );
  }
}
