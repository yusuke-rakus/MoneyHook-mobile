import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/data/data/category/commonCategoryStorage.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceLoad.dart';
import 'package:money_hooks/common/data/data/transaction/commonTransactionLoad.dart';
import 'package:money_hooks/common/data/data/transaction/commonTransactionStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonConfirmDialog.dart';
import 'package:money_hooks/common/widgets/commonLoadingDialog.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/common/widgets/gradientButton.dart';
import 'package:money_hooks/features/editTransaction/data/transaction/editTransactionApi.dart';
import 'package:money_hooks/features/editTransaction/icons/Dot.dart';
import 'package:money_hooks/features/editTransaction/selectCategory/selectCategory.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class EditTransaction extends StatefulWidget {
  const EditTransaction(this.transaction, this.env, this.setReload,
      {super.key});

  final TransactionClass transaction;
  final EnvClass env;
  final Function setReload;

  @override
  State<StatefulWidget> createState() => _EditTransaction();
}

class _EditTransaction extends State<EditTransaction> {
  late TransactionClass transaction;
  late EnvClass env;
  late List<TransactionClass> recommendList = [];
  late List<TransactionClass> receivedRecommendList = [];
  late List<PaymentResourceData> paymentResourceList = [];
  int recommendShowCount = 5;

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
    Future(() async {
      await CommonPaymentResourceLoad.getPaymentResource(
          env, setPaymentResourceList);
      if (!transaction.hasTransactionId()) {
        CommonTranTransactionLoad.getFrequentTransactionName(
            env, setRecommendList);
        _setDefaultCategory(transaction);

        final String? defPaymentRes =
            await CommonTranTransactionStorage.getDefaultPaymentResource();
        if (defPaymentRes != null) {
          PaymentResourceData selectedPayment = paymentResourceList
              .where((resource) => resource.paymentId == defPaymentRes)
              .toList()
              .first;
          setState(() {
            transaction.paymentId = selectedPayment.paymentId;
            transaction.paymentName = selectedPayment.paymentName;
          });
        }
      }
    });
  }

  Future<void> _setDefaultCategory(TransactionClass transaction) async {
    CategoryClass category = await CommonCategoryStorage.getDefaultValue();
    setState(() {
      transaction.categoryId = category.categoryId;
      transaction.categoryName = category.categoryName;
      transaction.subCategoryId = category.subCategoryId;
      transaction.subCategoryName = category.subCategoryName;
    });
  }

  // 取引候補
  void setRecommendList(List<TransactionClass> resultList) {
    setState(() {
      recommendList = resultList;
      receivedRecommendList = resultList;
    });
  }

  // 支払い方法
  void setPaymentResourceList(List<PaymentResourceData> resultList) {
    if (resultList.isNotEmpty) {
      setState(() {
        paymentResourceList.add(PaymentResourceData());
        for (var value in resultList) {
          paymentResourceList.add(value);
        }
      });
    }
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
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
  void _editTransaction(TransactionClass transaction, EnvClass env) {
    commonLoadingDialog(context: context);
    transaction.userId = env.userId;
    if (transaction.hasTransactionId()) {
      // 編集
      EditTransactionApi.editTransaction(
          transaction, backNavigation, setDisable, setSnackBar);
    } else {
      // 新規追加
      EditTransactionApi.addTransaction(
          transaction, backNavigation, setDisable, setSnackBar);
    }
  }

  // 削除処理
  void _deleteTransaction(EnvClass env, TransactionClass transaction) {
    commonLoadingDialog(context: context);
    EditTransactionApi.deleteTransaction(
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
            ? TransactionClass.formatNum(transaction.transactionAmount.toInt())
            : '');
    amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length));

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: GradientBar(),
              title: transaction.hasTransactionId()
                  ? Text('収支の編集')
                  : Text('収支の入力'),
              actions: [
                // 削除アイコン
                Visibility(
                  visible: transaction.hasTransactionId(),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Tooltip(
                      message: "削除",
                      child: IconButton(
                          onPressed: transaction.isDisabled()
                              ? null
                              : () {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          commonConfirmDialog(
                                              context: context,
                                              title: '取引を削除しますか',
                                              secondaryText: 'キャンセル',
                                              primaryText: '削除',
                                              primaryFunction: () {
                                                // 削除処理
                                                Navigator.pop(context);
                                                _deleteTransaction(
                                                    env, transaction);
                                              }));
                                },
                          icon: const Icon(
                            Icons.delete_outline,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            body: Stack(children: [
              ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  // 日付
                  CenterWidget(
                    child: InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateFormat('yyyy-MM-dd')
                              .parse(transaction.transactionDate),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime.now(),
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
                          setState(() => transaction.transactionDate =
                              DateFormat('yyyy-MM-dd').format(picked));
                        }
                      },
                      child: SizedBox(
                        height: 50,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${transaction.transactionDate.replaceAll('-', '月').replaceFirst('月', '年')}日',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Icon(Icons.edit),
                          ],
                        )),
                      ),
                    ),
                  ),
                  // 金額
                  CenterWidget(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    height: 80,
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
                          curveType: Curves.easeOutExpo,
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
                              // 全角数字を半角に変換
                              String halfWidthValue = value.replaceAllMapped(
                                RegExp(r'[０-９]'),
                                (match) => String.fromCharCode(
                                    match.group(0)!.codeUnitAt(0) -
                                        0xFF10 +
                                        0x30),
                              );

                              if (value != halfWidthValue) {
                                amountController.text = halfWidthValue;
                                amountController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: halfWidthValue.length),
                                );
                              }

                              setState(() {
                                if (halfWidthValue.isNotEmpty) {
                                  transaction.transactionAmount =
                                      TransactionClass.formatInt(
                                          halfWidthValue);
                                } else {
                                  transaction.transactionAmount = 0;
                                }
                              });
                            },
                            controller: amountController,
                            decoration: InputDecoration(
                                hintText: '¥0',
                                hintStyle:
                                    TextStyle(fontSize: 20, letterSpacing: 8),
                                errorText: transaction
                                        .transactionAmountError.isNotEmpty
                                    ? transaction.transactionAmountError
                                    : null),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9０-９]')),
                            ],
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 取引名
                  CenterWidget(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    height: 80,
                    alignment: Alignment.center,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          transaction.transactionName = value;
                          for (var item in receivedRecommendList) {
                            if (value == item.transactionName) {
                              transaction.categoryId = item.categoryId;
                              transaction.categoryName = item.categoryName;
                              transaction.subCategoryId = item.subCategoryId;
                              transaction.subCategoryName =
                                  item.subCategoryName;
                              transaction.fixedFlg = item.fixedFlg;
                              transaction.paymentId = item.paymentId;
                              CommonSnackBar.build(
                                  context: context, text: "自動補完しました");
                            }
                          }
                          recommendList = receivedRecommendList
                              .where((item) => item.transactionName
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: '取引名',
                          errorText: transaction.transactionNameError.isNotEmpty
                              ? transaction.transactionNameError
                              : null),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // 候補リスト
                  CenterWidget(
                    padding: const EdgeInsets.only(left: 40, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Wrap(children: [
                      ...recommendList.take(recommendShowCount).map<Widget>(
                            (tran) => Container(
                              height: 23,
                              margin: const EdgeInsets.only(top: 3, right: 5),
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  nameController.text = tran.transactionName;
                                  transaction.transactionName =
                                      tran.transactionName;
                                  transaction.categoryId = tran.categoryId;
                                  transaction.categoryName = tran.categoryName;
                                  transaction.subCategoryId =
                                      tran.subCategoryId;
                                  transaction.subCategoryName =
                                      tran.subCategoryName;
                                  transaction.fixedFlg = tran.fixedFlg;
                                  transaction.paymentId = tran.paymentId;
                                }),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.black12,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                child: Text(tran.transactionName),
                              ),
                            ),
                          ),
                      Visibility(
                        visible: recommendShowCount <= recommendList.length,
                        child: IconButton(
                          splashRadius: 14,
                          onPressed: () => setState(() {
                            recommendShowCount += 5;
                          }),
                          icon: const Icon(Dot.dot, size: 20.0),
                        ),
                      )
                    ]),
                  ),
                  // カテゴリ
                  CenterWidget(
                      padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
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
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 300),
                                        transitionBuilder: (child, animation) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        child: Text(
                                          '${transaction.categoryName} / ${transaction.subCategoryName}',
                                          key: ValueKey<String>(
                                              '${transaction.categoryName}_${transaction.subCategoryName}'),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                  // 支払い元選択
                  paymentResourceList.isNotEmpty
                      ? CenterWidget(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('支払方法', style: TextStyle(fontSize: 15)),
                              const SizedBox(width: 10),
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 250,
                                  ),
                                  child: DropdownButton(
                                    hint: Text("支払方法"),
                                    isExpanded: true,
                                    items: paymentResourceList
                                        .map((resource) => DropdownMenuItem(
                                              value: resource.paymentId,
                                              child: Text(
                                                resource.paymentName,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        PaymentResourceData selectedPayment =
                                            paymentResourceList
                                                .where((resource) =>
                                                    resource.paymentId == value)
                                                .toList()
                                                .first;
                                        transaction.paymentId =
                                            selectedPayment.paymentId;
                                        transaction.paymentName =
                                            selectedPayment.paymentName;
                                      });
                                    },
                                    value: transaction.paymentId,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  // 固定費フラグ
                  CenterWidget(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    height: 100,
                    child: CheckboxListTile(
                      activeColor: Colors.blue,
                      title: Text('固定費として計算する', style: TextStyle(fontSize: 15)),
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
                          constraints: const BoxConstraints(maxWidth: 800),
                          color: Colors.white,
                          height: 60,
                          width: double.infinity,
                          child: GradientButton(
                              onPressed: transaction.isDisabled()
                                  ? null
                                  : () {
                                      setState(() {
                                        _editTransaction(transaction, env);
                                      });
                                    },
                              borderRadius: 25,
                              child: Text(
                                '登録',
                                style:
                                    TextStyle(fontSize: 23, letterSpacing: 20),
                              )))))
            ])),
      ),
    );
  }

  /// 登録ボタン押下後のダイアログ
  AlertDialog _confirmDialog() {
    return commonConfirmDialog(
        context: context,
        title: '入力が完了しました',
        secondaryText: '連続入力',
        primaryText: '完了',
        primaryFunction: () {
          Navigator.pop(context);
          Navigator.pop(context);
          widget.setReload();
        },
        secondaryFunction: () {
          setState(() {
            nameController.text = '';
            transaction.transactionName = '';
            transaction.transactionAmount = 0;
            transaction.fixedFlg = false;
            transaction.isDisable = false;
            _setDefaultCategory(transaction);
            transaction.paymentId = null;
          });
        });
  }
}
