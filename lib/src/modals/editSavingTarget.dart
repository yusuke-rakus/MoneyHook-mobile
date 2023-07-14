import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:money_hooks/src/api/savingTargetApi.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../class/savingTargetClass.dart';

class EditSavingTarget extends StatefulWidget {
  EditSavingTarget(this.savingTarget, this.env, this.setReload, {super.key});

  savingTargetClass savingTarget;
  envClass env;
  Function setReload;

  @override
  State<EditSavingTarget> createState() => _EditSavingTarget();
}

class _EditSavingTarget extends State<EditSavingTarget> {
  late savingTargetClass savingTarget;
  late envClass env;
  late String errorMessage = '';

  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    savingTarget = widget.savingTarget;
    env = widget.env;

    nameController.value =
        nameController.value.copyWith(text: savingTarget.savingTargetName);
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
  }

  void backNavigation() {
    widget.setReload();
    Navigator.pop(context);
  }

  // ボタン非表示処理
  void setDisable() {
    setState(() {
      savingTarget.isDisable = !savingTarget.isDisable;
    });
  }

  // エラーメッセージ
  void setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  // 登録処理
  void _editSavingTarget(savingTargetClass savingTarget, envClass env) {
    savingTarget.userId = env.userId;
    if (savingTarget.hasTargetId()) {
      // 編集
      SavingTargetApi.editSavingTarget(
          savingTarget, backNavigation, setDisable, setErrorMessage);
    } else {
      //  新規追加
      SavingTargetApi.addSavingTarget(
          savingTarget, backNavigation, setDisable, setErrorMessage);
    }
  }

  // 削除処理
  void _deleteSavingTarget(envClass env, savingTargetClass savingTarget) {
    SavingTargetApi.deleteSavingTarget(
        env, savingTarget, backNavigation, setDisable, setErrorMessage);
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final amountController = TextEditingController(
        text: savingTarget.targetAmount != 0
            ? savingTargetClass.formatNum(savingTarget.targetAmount.toInt())
            : '');
    amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length));

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
            appBar: AppBar(
              title: savingTarget.hasTargetId()
                  ? const Text('目標の編集')
                  : const Text('目標の追加'),
              actions: [
                // 削除アイコン
                Visibility(
                  visible: savingTarget.hasTargetId(),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: savingTarget.isDisabled()
                            ? null
                            : () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CupertinoAlertDialog(
                                            title: const Text('目標を削除しますか'),
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
                                                    _deleteSavingTarget(
                                                        env, savingTarget);
                                                    Navigator.pop(context);
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
            body: Stack(
              children: [
                // 項目リスト
                ListView(padding: const EdgeInsets.all(8), children: [
                  // 目標名称
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    height: 150,
                    alignment: Alignment.center,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          savingTarget.savingTargetName = value;
                        });
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: '目標名称',
                          errorText:
                              savingTarget.savingTargetNameError.isNotEmpty
                                  ? savingTarget.savingTargetNameError
                                  : null),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  // 目標金額
                  Container(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      height: 150,
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    savingTarget.targetAmount =
                                        int.parse(value);
                                  } else {
                                    savingTarget.targetAmount = 0;
                                  }
                                });
                              },
                              controller: amountController,
                              decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: const TextStyle(
                                      fontSize: 20, letterSpacing: 8),
                                  errorText:
                                      savingTarget.targetAmountError.isNotEmpty
                                          ? savingTarget.targetAmountError
                                          : null),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const Text(
                            '円',
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ]),
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
                        onPressed: savingTarget.isDisabled()
                            ? null
                            : () {
                                setState(() {
                                  _editSavingTarget(savingTarget, env);
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          fixedSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          '登録',
                          style: TextStyle(fontSize: 23, letterSpacing: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                // エラーメッセージ
                Visibility(
                    visible: errorMessage.isNotEmpty,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            errorMessage = '';
                          });
                        },
                        child: Card(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: errorMessage,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                const WidgetSpan(
                                  child: Icon(Icons.close_outlined,
                                      size: 22, color: Colors.white),
                                )
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
