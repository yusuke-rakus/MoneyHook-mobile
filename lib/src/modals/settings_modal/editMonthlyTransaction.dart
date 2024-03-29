import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:money_hooks/src/api/monthlyTransactionApi.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/selectCategory.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

import '../../class/monthlyTransactionClass.dart';
import '../../components/commonLoadingDialog.dart';
import '../../components/deleteConfirmDialog.dart';

class EditMonthlyTransaction extends StatefulWidget {
  const EditMonthlyTransaction(
      this.monthlyTransaction, this.env, this.setReload, this.setSnackBar,
      {super.key});

  final MonthlyTransactionClass monthlyTransaction;
  final envClass env;
  final Function setReload;
  final Function setSnackBar;

  @override
  State<StatefulWidget> createState() => _EditTransaction();
}

class _EditTransaction extends State<EditMonthlyTransaction> {
  late MonthlyTransactionClass monthlyTransaction;
  late envClass env;

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

  // 戻る・更新処理
  void backNavigation() {
    Navigator.pop(context);
    Navigator.pop(context);
    widget.setReload();
  }

  // 登録処理
  void _editTransaction(
      MonthlyTransactionClass monthlyTransaction, envClass env) {
    commonLoadingDialog(context: context);
    monthlyTransaction.userId = env.userId;
    MonthlyTransactionApi.editTransaction(
        monthlyTransaction, backNavigation, widget.setSnackBar, setDisable);
  }

  // 削除処理
  void _deleteTransaction(
      envClass env, MonthlyTransactionClass monthlyTransaction) {
    commonLoadingDialog(context: context);
    monthlyTransaction.userId = env.userId;
    MonthlyTransactionApi.deleteMonthlyTransaction(
        monthlyTransaction, backNavigation, widget.setSnackBar, setDisable);
  }

  // ボタン非表示処理
  void setDisable() {
    setState(() {
      monthlyTransaction.isDisable = !monthlyTransaction.isDisable;
      if (!monthlyTransaction.isDisable) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final TextEditingController amountController = TextEditingController(
        text: monthlyTransaction.monthlyTransactionAmount != 0
            ? MonthlyTransactionClass.formatNum(
                monthlyTransaction.monthlyTransactionAmount.toInt())
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
                  ? const Text('月次収支の編集')
                  : const Text('月次収支の追加'),
              actions: [
                // 削除アイコン
                Visibility(
                  visible: monthlyTransaction.hasMonthlyTransactionId(),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: monthlyTransaction.isDisabled()
                            ? null
                            : () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        deleteConfirmDialog(
                                            context: context,
                                            title: '目標を削除しますか',
                                            leftText: 'キャンセル',
                                            rightText: '削除',
                                            isDestructiveAction: true,
                                            function: () {
                                              // 削除処理
                                              Navigator.pop(context);
                                              _deleteTransaction(
                                                  env, monthlyTransaction);
                                            }));
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
                                  MonthlyTransactionClass.formatInt(value);
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
                                    .monthlyTransactionDateError.isNotEmpty
                                ? monthlyTransaction.monthlyTransactionDateError
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
                                      MonthlyTransactionClass.formatInt(value);
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
                                  monthlyTransaction.categoryName.isNotEmpty
                                      ? '${monthlyTransaction.categoryName} / ${widget.monthlyTransaction.subCategoryName}'
                                      : '',
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
