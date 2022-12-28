import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/selectCategory.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

import '../class/transactionClass.dart';

class EditTransaction extends StatefulWidget {
  EditTransaction(this.transaction, this.env, this.setReload, {super.key});

  transactionClass transaction;
  envClass env;
  Function setReload;

  @override
  State<StatefulWidget> createState() => _EditTransaction();
}

class _EditTransaction extends State<EditTransaction> {
  late transactionClass transaction;
  late envClass env;

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
    env = widget.env;
  }

  void backNavigation() {
    Navigator.pop(context);
    widget.setReload();
  }

  void _editTransaction(transactionClass transaction, envClass env) {
    transaction.userId = env.userId;
    if (transaction.hasTransactionId()) {
      // 編集
      transactionApi.editTransaction(transaction, backNavigation);
    } else {
      // 新規追加
      transactionApi.addTransaction(transaction, backNavigation);
    }
  }

  void _deleteTransaction(envClass env, transactionClass transaction) {
    transactionApi.deleteTransaction(env, transaction, backNavigation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: transaction.hasTransactionId()
              ? const Text('収支の編集')
              : const Text('支出または収入の入力'),
          actions: [
            // 削除アイコン
            Visibility(
              visible: transaction.hasTransactionId(),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: const Text('この取引を削除します'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)))),
                                    child: const Text(
                                      '中止',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // 削除処理
                                      _deleteTransaction(env, transaction);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE53935),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)))),
                                    child: const Text(
                                      '削除',
                                    ),
                                  )
                                ],
                              ));
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                    )),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            // 日付
            InkWell(
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (_) => Container(
                    height: 250,
                    color: Colors.white,
                    child: CupertinoDatePicker(
                      initialDateTime: DateFormat('yyyy-MM-dd')
                          .parse(transaction.transactionDate),
                      onDateTimeChanged: (value) {
                        setState(() {
                          transaction.transactionDate =
                              DateFormat('yyyy-MM-dd').format(value);
                        });
                      },
                      minimumYear: DateTime.now().year - 1,
                      maximumYear: DateTime.now().year,
                      maximumDate: DateTime.now(),
                      dateOrder: DatePickerDateOrder.ymd,
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                );
              },
              child: SizedBox(
                height: 60,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${transaction.transactionDate.replaceAll('-', '月').replaceFirst('月', '年')}日',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Icon(Icons.edit),
                  ],
                )),
              ),
            ),
            // 金額
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40),
              height: 100,
              // color: Colors.cyanAccent,
              child: Row(
                children: [
                  Switcher(
                    value: transaction.transactionSign > 0 ? true : false,
                    size: SwitcherSize.medium,
                    enabledSwitcherButtonRotate: false,
                    onChanged: (bool state) {
                      state
                          ? transaction.transactionSign = 1
                          : transaction.transactionSign = -1;
                    },
                    iconOff: Icons.remove,
                    colorOff: Colors.red,
                    iconOn: Icons.add,
                    colorOn: Colors.green,
                  ),
                  Container(
                    width: 20,
                  ),
                  Flexible(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            transaction.transactionAmount = int.parse(value);
                          } else {
                            transaction.transactionAmount = 0;
                          }
                        });
                      },
                      controller: TextEditingController(
                          text: transaction.transactionAmount != 0
                              ? transaction.transactionAmount.toString()
                              : ''),
                      decoration: const InputDecoration(
                          hintText: '¥0',
                          hintStyle: TextStyle(fontSize: 20, letterSpacing: 8)),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            // 取引名
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40),
              height: 100,
              alignment: Alignment.center,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    transaction.transactionName = value;
                  });
                },
                controller:
                    TextEditingController(text: transaction.transactionName),
                decoration: const InputDecoration(labelText: '取引名'),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            // カテゴリ
            Container(
              margin: const EdgeInsetsDirectional.fromSTEB(40, 30, 40, 30),
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
                    transaction.subCategoryName = result['subCategoryName'];
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${transaction.categoryName} / ${widget.transaction.subCategoryName}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 固定費フラグ
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 40, right: 40),
              height: 100,
              child: CheckboxListTile(
                activeColor: Colors.blue,
                title: const Text('固定費として計算する'),
                value: transaction.fixedFlg,
                onChanged: (value) {
                  setState(() {
                    transaction.fixedFlg = !transaction.fixedFlg;
                  });
                },
              ),
            ),
            // 登録
            SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: transaction.isDisabled()
                      ? null
                      : () {
                          _editTransaction(transaction, env);
                        },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)))),
                  child: const Text(
                    '登録',
                    style: TextStyle(fontSize: 23, letterSpacing: 20),
                  ),
                )),
          ],
        ));
  }
}
