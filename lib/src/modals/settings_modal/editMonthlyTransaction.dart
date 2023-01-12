import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/selectCategory.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

import '../../class/monthlyTransactionClass.dart';

class EditMonthlyTransaction extends StatefulWidget {
  EditMonthlyTransaction(this.monthlyTransaction, this.env, this.setReload,
      {super.key});

  monthlyTransactionClass monthlyTransaction;
  envClass env;
  Function setReload;

  @override
  State<StatefulWidget> createState() => _EditTransaction();
}

class _EditTransaction extends State<EditMonthlyTransaction> {
  late monthlyTransactionClass monthlyTransaction;
  late envClass env;
  late List<String> recommendList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // 初期処理
  @override
  void initState() {
    super.initState();
    monthlyTransaction = widget.monthlyTransaction;
    env = widget.env;

    nameController.value = nameController.value
        .copyWith(text: monthlyTransaction.monthlyTransactionName);
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    dateController.value = dateController.value
        .copyWith(text: monthlyTransaction.monthlyTransactionDate.toString());
    dateController.selection = TextSelection.fromPosition(
        TextPosition(offset: dateController.text.length));
  }

  // 取引候補
  void setRecommendList(List<String> resultList) {
    setState(() {
      recommendList = resultList;
    });
  }

  // 戻る・更新処理
  void backNavigation() {
    Navigator.pop(context);
    widget.setReload();
  }

  // 登録処理
  void _editTransaction(
      monthlyTransactionClass monthlyTransaction, envClass env) {
    monthlyTransaction.userId = env.userId;
    // if (monthlyTransaction.hasMonthlyTransactionId()) {
    //   // 編集
    //   transactionApi.editTransaction(monthlyTransaction, backNavigation);
    // } else {
    //   // 新規追加
    //   transactionApi.addTransaction(monthlyTransaction, backNavigation);
    // }
  }

  // 削除処理
  void _deleteTransaction(
      envClass env, monthlyTransactionClass monthlyTransaction) {
    // transactionApi.deleteTransaction(env, monthlyTransaction, backNavigation);
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final TextEditingController amountController = TextEditingController(
        text: monthlyTransaction.monthlyTransactionAmount != 0
            ? monthlyTransactionClass
                .formatNum(monthlyTransaction.monthlyTransactionAmount.toInt())
            : '');
    amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length));

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
            appBar: AppBar(
              title: monthlyTransaction.hasMonthlyTransactionId()
                  ? const Text('収支の編集')
                  : const Text('支出または収入の入力'),
              actions: [
                // 削除アイコン
                Visibility(
                  visible: monthlyTransaction.hasMonthlyTransactionId(),
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
                                          // 削除処理
                                          _deleteTransaction(
                                              env, monthlyTransaction);
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFE53935),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)))),
                                        child: const Text('削除'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('閉じる'),
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
            body: Stack(children: [
              ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  // 日付
                  Row(children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              monthlyTransaction.monthlyTransactionDate =
                                  monthlyTransactionClass.formatInt(value);
                            } else {
                              monthlyTransaction.monthlyTransactionDate = 0;
                            }
                          });
                        },
                        controller: dateController,
                        decoration: InputDecoration(
                            hintStyle:
                                const TextStyle(fontSize: 20, letterSpacing: 8),
                            errorText: monthlyTransaction
                                    .monthlyTransactionAmountError.isNotEmpty
                                ? monthlyTransaction
                                    .monthlyTransactionAmountError
                                : null),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const Text(
                      '日',
                      style: TextStyle(fontSize: 17),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ]),
                  // 金額
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    height: 100,
                    child: Row(
                      children: [
                        Switcher(
                          value: monthlyTransaction.monthlyTransactionSign > 0
                              ? true
                              : false,
                          size: SwitcherSize.medium,
                          enabledSwitcherButtonRotate: false,
                          onChanged: (bool state) {
                            state
                                ? monthlyTransaction.monthlyTransactionSign = 1
                                : monthlyTransaction.monthlyTransactionSign =
                                    -1;
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
                                  monthlyTransaction.monthlyTransactionAmount =
                                      monthlyTransactionClass.formatInt(value);
                                } else {
                                  monthlyTransaction.monthlyTransactionAmount =
                                      0;
                                }
                              });
                            },
                            controller: amountController,
                            decoration: InputDecoration(
                                hintText: '¥0',
                                hintStyle: const TextStyle(
                                    fontSize: 20, letterSpacing: 8),
                                errorText: monthlyTransaction
                                        .monthlyTransactionAmountError
                                        .isNotEmpty
                                    ? monthlyTransaction
                                        .monthlyTransactionAmountError
                                    : null),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                          monthlyTransaction.monthlyTransactionName = value;
                        });
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: '取引名',
                          errorText: monthlyTransaction
                                  .monthlyTransactionNameError.isNotEmpty
                              ? monthlyTransaction.monthlyTransactionNameError
                              : null),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  // カテゴリ
                  Container(
                    margin:
                        const EdgeInsetsDirectional.fromSTEB(40, 30, 40, 30),
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
                          monthlyTransaction.categoryName =
                              result['categoryName'];
                          monthlyTransaction.categoryId = result['categoryId'];
                          monthlyTransaction.subCategoryName =
                              result['subCategoryName'];
                          monthlyTransaction.subCategoryId =
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${monthlyTransaction.categoryName} / ${widget.monthlyTransaction.subCategoryName}',
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
                ],
              ),
              // 登録
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: monthlyTransaction.isDisabled()
                            ? null
                            : () {
                                setState(() {
                                  _editTransaction(monthlyTransaction, env);
                                });
                              },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)))),
                        child: const Text(
                          '登録',
                          style: TextStyle(fontSize: 23, letterSpacing: 20),
                        ),
                      ),
                    )),
              )
            ])),
      ),
    );
  }
}
