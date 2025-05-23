import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:money_hooks/common/class/monthlyTransactionClass.dart';
import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceLoad.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonConfirmDialog.dart';
import 'package:money_hooks/common/widgets/commonLoadingDialog.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/common/widgets/gradientButton.dart';
import 'package:money_hooks/features/editTransaction/selectCategory/selectCategory.dart';
import 'package:money_hooks/features/settings/data/monthlyTransaction/monthlyTransactionApi.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class EditMonthlyTransaction extends StatefulWidget {
  const EditMonthlyTransaction(
      this.monthlyTransaction, this.env, this.setReload, this.setSnackBar,
      {super.key});

  final MonthlyTransactionClass monthlyTransaction;
  final EnvClass env;
  final Function setReload;
  final Function setSnackBar;

  @override
  State<StatefulWidget> createState() => _EditTransaction();
}

class _EditTransaction extends State<EditMonthlyTransaction> {
  late MonthlyTransactionClass monthlyTransaction;
  late EnvClass env;
  late List<PaymentResourceData> paymentResourceList = [];

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
    CommonPaymentResourceLoad.getPaymentResource(env, setPaymentResourceList);
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

  // 戻る・更新処理
  void backNavigation() {
    Navigator.pop(context);
    Navigator.pop(context);
    widget.setReload();
  }

  // 登録処理
  void _editTransaction(
      MonthlyTransactionClass monthlyTransaction, EnvClass env) {
    commonLoadingDialog(context: context);
    monthlyTransaction.userId = env.userId;
    if (monthlyTransaction.hasMonthlyTransactionId()) {
      // 月次取引の編集
      MonthlyTransactionApi.editTransaction(
          monthlyTransaction, backNavigation, widget.setSnackBar, setDisable);
    } else {
      // 月次取引の追加
      MonthlyTransactionApi.addTransaction(
          monthlyTransaction, backNavigation, widget.setSnackBar, setDisable);
    }
  }

  // 削除処理
  void _deleteTransaction(
      EnvClass env, MonthlyTransactionClass monthlyTransaction) {
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
              flexibleSpace: GradientBar(),
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
                                        commonConfirmDialog(
                                            context: context,
                                            title: '目標を削除しますか',
                                            secondaryText: 'キャンセル',
                                            primaryText: '削除',
                                            primaryFunction: () {
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
                  CenterWidget(
                    child: Row(children: [
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
                                  TextStyle(fontSize: 20, letterSpacing: 8),
                              errorText: monthlyTransaction
                                      .monthlyTransactionDateError.isNotEmpty
                                  ? monthlyTransaction
                                      .monthlyTransactionDateError
                                  : null),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(
                        '日',
                        style: TextStyle(fontSize: 17),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                    ]),
                  ),
                  // 金額
                  CenterWidget(
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
                                hintStyle:
                                    TextStyle(fontSize: 20, letterSpacing: 8),
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
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 取引名
                  CenterWidget(
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
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // カテゴリ
                  CenterWidget(
                    padding:
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
                                  style: TextStyle(fontSize: 20),
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
                  // 支払い元選択
                  paymentResourceList.isNotEmpty
                      ? CenterWidget(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 250,
                                child: DropdownButton(
                                  hint: const Text("支払方法"),
                                  isExpanded: true,
                                  items: paymentResourceList
                                      .map((resource) => DropdownMenuItem(
                                            value: resource.paymentId,
                                            child: Text(resource.paymentName),
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
                                      monthlyTransaction.paymentId =
                                          selectedPayment.paymentId;
                                      monthlyTransaction.paymentName =
                                          selectedPayment.paymentName;
                                    });
                                  },
                                  value: monthlyTransaction.paymentId,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
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
                        onPressed: monthlyTransaction.isDisabled()
                            ? null
                            : () {
                                setState(() {
                                  _editTransaction(monthlyTransaction, env);
                                });
                              },
                        borderRadius: 25,
                        child: Text(
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
