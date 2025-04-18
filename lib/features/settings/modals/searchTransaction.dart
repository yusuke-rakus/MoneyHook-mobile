import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/features/settings/class/searchTransactionData.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/cardWidget.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingDialog.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/common/widgets/gradientButton.dart';
import 'package:money_hooks/features/editTransaction/selectCategory/selectCategoryForSearch.dart';
import 'package:money_hooks/features/settings/data/transaction/searchTranTransactionApi.dart';

class SearchTransaction extends StatefulWidget {
  const SearchTransaction({super.key, required this.env});

  final EnvClass env;

  @override
  State<SearchTransaction> createState() => _SearchTransaction();
}

class _SearchTransaction extends State<SearchTransaction> {
  late EnvClass env;
  late bool _isLoading;
  late SearchTransactionData resultData = SearchTransactionData();
  TransactionClass transaction = TransactionClass();
  String searchTitle = '';

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  void setStartMonth(String value) {
    transaction.startMonth = value;
  }

  void setEndMonth(String value) {
    transaction.endMonth = value;
  }

  void setTransactionList(
      int totalSpending, List<Map<String, dynamic>> resultList) {
    setState(() {
      resultData.totalSpending = totalSpending;
      resultData.monthlyVariableList = resultList;
    });
  }

  void searchTransaction() {
    commonLoadingDialog(context: context);
    SearchTranTransactionApi.getTotalSpending(
            env, transaction, setTransactionList, setSnackBar)
        .then((value) => Navigator.pop(context));
  }

  DateTime _lastDayOfMonth(DateTime date) {
    var beginningNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1));
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = false;

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
          flexibleSpace: GradientBar(),
          title: (const Text('設定')),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ListView(
            children: [
              CenterWidget(
                child: CardWidget(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(
                      searchTitle,
                      style: TextStyle(fontSize: 20),
                    ),
                    textColor: Colors.black,
                    initiallyExpanded: true,
                    onExpansionChanged: (isOpen) {
                      setState(() {
                        if (isOpen) {
                          searchTitle = '';
                        } else {
                          if (transaction.categoryName.isNotEmpty) {
                            searchTitle =
                                '${transaction.categoryName} / ${transaction.subCategoryName}';
                          }
                          searchTitle +=
                              ' ${transaction.startMonth} : ${transaction.endMonth}';
                        }
                      });
                    },
                    children: [
                      // カテゴリタイトル
                      Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
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
                                    builder: (context) =>
                                        SelectCategoryForSearch(env),
                                  ),
                                );
                                if (result == null) return;
                                setState(() {
                                  transaction.categoryName =
                                      result['categoryName'];
                                  transaction.categoryId = result['categoryId'];
                                  transaction.subCategoryName =
                                      result['subCategoryName'];
                                  transaction.subCategoryId =
                                      result['subCategoryId'];
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
                                              transaction
                                                      .categoryName.isNotEmpty
                                                  ? '${transaction.categoryName} / ${transaction.subCategoryName}'
                                                  : '',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            const Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  size: 30,
                                                ))
                                          ]))))),
                      // 期間タイトル
                      Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
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
                                  child: GradientButton(
                                      onPressed: () => searchTransaction(),
                                      child: Text(
                                        '検索',
                                        style: TextStyle(
                                            fontSize: 23, letterSpacing: 20),
                                      )))))
                    ],
                  ),
                ),
              ),
              resultData.monthlyVariableList.isNotEmpty
                  ? CenterWidget(
                      child: Column(
                        children: [
                          // 検索結果タイトル
                          Container(
                              padding: const EdgeInsets.only(left: 20, top: 30),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '検索結果',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))),
                          Center(
                              // 検索結果
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  itemCount:
                                      resultData.monthlyVariableList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _variableAccordion(context,
                                        resultData.monthlyVariableList[index]);
                                  }))
                        ],
                      ),
                    )
                  : const SizedBox(),
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
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateFormat('yyyy-MM-dd').parse(targetMonth),
          firstDate: DateTime(DateTime.now().year - 10),
          lastDate: _lastDayOfMonth(DateTime.now()),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                datePickerTheme: const DatePickerThemeData(
                    headerBackgroundColor: Colors.blue,
                    headerForegroundColor: Colors.white,
                    dividerColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                colorScheme: const ColorScheme.light(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() => setFunction(DateFormat('yyyy-MM-dd').format(picked)));
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '${targetMonth.replaceAll('-', '月').replaceFirst('月', '年')}日',
                    style: TextStyle(fontSize: 20)),
                const Icon(Icons.edit),
              ],
            )
          ],
        ),
      ),
    );
  }

  // アコーディオン
  Widget _variableAccordion(
      BuildContext context, Map<String, dynamic> monthlyVariableList) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${monthlyVariableList['category_name']}'),
              Text(
                  '¥${TransactionClass.formatNum(monthlyVariableList['category_total_amount'].abs())}'),
            ],
          ),
          textColor: Colors.black,
          children: monthlyVariableList['sub_category_list']
              .map<Widget>((subCategory) => Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(subCategory['sub_category_name']),
                          Text(
                              '¥${TransactionClass.formatNum(subCategory['sub_category_total_amount'].abs())}'),
                        ],
                      ),
                      textColor: Colors.black,
                      children: subCategory['transaction_list']
                          .map<Widget>((tran) => ListTile(
                                  title: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      tran['transaction_name'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        const Expanded(child: SizedBox()),
                                        Text(
                                            '¥${TransactionClass.formatNum(tran['transaction_amount'].abs())}'),
                                      ],
                                    ),
                                  ),
                                ],
                              )))
                          .toList(),
                    ),
                  ))
              .toList()),
    );
  }
}
