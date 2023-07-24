import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/dataLoader/transactionLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/selectCategory.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

import '../class/transactionClass.dart';
import '../components/commonLoadingDialog.dart';
import '../components/commonSnackBar.dart';
import '../searchStorage/categoryStorage.dart';

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
  late List<transactionClass> recommendList = [];

  final TextEditingController nameController = TextEditingController();

  // 初期処理
  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
    env = widget.env;

    nameController.value =
        nameController.value.copyWith(text: transaction.transactionName);
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    if (!transaction.hasTransactionId()) {
      TransactionLoad.getFrequentTransactionName(env, setRecommendList);
      _setDefaultCategory(transaction);
    }
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

  // 取引候補
  void setRecommendList(List<transactionClass> resultList) {
    setState(() {
      recommendList = resultList;
    });
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  // 戻る・更新処理
  void backNavigation({required bool isUpdate}) {
    Navigator.pop(context);
    if (isUpdate) {
      Navigator.pop(context);
      widget.setReload();
    } else {
      showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => _confirmDialog());
    }
  }

  // 登録処理
  void _editTransaction(transactionClass transaction, envClass env) {
    commonLoadingDialog(context: context);
    transaction.userId = env.userId;
    if (transaction.hasTransactionId()) {
      // 編集
      transactionApi.editTransaction(
          transaction, backNavigation, setDisable, setSnackBar);
    } else {
      // 新規追加
      transactionApi.addTransaction(
          transaction, backNavigation, setDisable, setSnackBar);
    }
  }

  // 削除処理
  void _deleteTransaction(envClass env, transactionClass transaction) {
    commonLoadingDialog(context: context);
    transactionApi.deleteTransaction(
        env, transaction, backNavigation, setDisable, setSnackBar);
  }

  // ボタン非表示処理
  void setDisable() {
    setState(() {
      transaction.isDisable = !transaction.isDisable;
      if (!transaction.isDisable) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final TextEditingController amountController = TextEditingController(
        text: transaction.transactionAmount != 0
            ? transactionClass.formatNum(transaction.transactionAmount.toInt())
            : '');
    amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length));

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
            appBar: AppBar(
              title: transaction.hasTransactionId()
                  ? const Text('収支の編集')
                  : const Text('収支の入力'),
              actions: [
                // 削除アイコン
                Visibility(
                  visible: transaction.hasTransactionId(),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: transaction.isDisabled()
                            ? null
                            : () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoAlertDialog(
                                            title: const Text('取引を削除しますか'),
                                            actions: [
                                              CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  onPressed: () {
                                                    // キャンセル処理
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('キャンセル')),
                                              CupertinoDialogAction(
                                                  isDestructiveAction: true,
                                                  onPressed: () {
                                                    // 削除処理
                                                    Navigator.pop(context);
                                                    _deleteTransaction(
                                                        env, transaction);
                                                  },
                                                  child: const Text('削除'))
                                            ]));
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
                                  transaction.transactionAmount =
                                      transactionClass.formatInt(value);
                                } else {
                                  transaction.transactionAmount = 0;
                                }
                              });
                            },
                            controller: amountController,
                            decoration: InputDecoration(
                                hintText: '¥0',
                                hintStyle: const TextStyle(
                                    fontSize: 20, letterSpacing: 8),
                                errorText: transaction
                                        .transactionAmountError.isNotEmpty
                                    ? transaction.transactionAmountError
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
                          transaction.transactionName = value;
                        });
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: '取引名',
                          errorText: transaction.transactionNameError.isNotEmpty
                              ? transaction.transactionNameError
                              : null),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  // 候補リスト
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                        children: recommendList
                            .map<Widget>(
                              (tran) => Container(
                                height: 23,
                                margin: const EdgeInsets.only(top: 3, right: 5),
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      nameController.text =
                                          tran.transactionName;
                                      transaction.transactionName =
                                          tran.transactionName;
                                      transaction.categoryId = tran.categoryId;
                                      transaction.categoryName =
                                          tran.categoryName;
                                      transaction.subCategoryId =
                                          tran.subCategoryId;
                                      transaction.subCategoryName =
                                          tran.subCategoryName;
                                      transaction.fixedFlg = tran.fixedFlg;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      foregroundColor: Colors.black87,
                                      backgroundColor: Colors.black12,
                                      side: const BorderSide(
                                          color: Colors.white)),
                                  child: Text(tran.transactionName),
                                ),
                              ),
                            )
                            .toList()),
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
                  const SizedBox(
                    height: 100,
                  )
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
                        onPressed: transaction.isDisabled()
                            ? null
                            : () {
                                setState(() {
                                  _editTransaction(transaction, env);
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
              ),
            ])),
      ),
    );
  }

  /// 登録ボタン押下後のダイアログ
  AlertDialog _confirmDialog() {
    return AlertDialog(
      title: const Text('入力が完了しました'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  shape: const StadiumBorder()),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  nameController.text = '';
                  transaction.transactionName = '';
                  transaction.transactionAmount = 0;
                  transaction.fixedFlg = false;
                  transaction.isDisable = false;
                  _setDefaultCategory(transaction);
                });
              },
              child: const Text('連続入力')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                shape: const StadiumBorder(),
                backgroundColor: Colors.grey),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.setReload();
            },
            child: const Text('完了'),
          )
        ],
      ),
    );
  }
}
