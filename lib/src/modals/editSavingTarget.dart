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

  void _editSavingTarget(savingTargetClass savingTarget, envClass env) {
    savingTarget.userId = env.userId;
    if (savingTarget.hasTargetId()) {
      // 編集
      savingTargetApi.editSavingTarget(savingTarget, backNavigation);
    } else {
      //  新規追加
      savingTargetApi.addSavingTarget(savingTarget, backNavigation);
    }
  }

  void _deleteSavingTarget(envClass env, savingTargetClass savingTarget) {
    savingTargetApi.deleteSavingTarget(env, savingTarget, backNavigation);
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
                        onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    content: const Text('この目標を削除します'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // 削除処理
                                          _deleteSavingTarget(
                                              env, savingTarget);
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
            body: Stack(
              children: [
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
                )
              ],
            )),
      ),
    );
  }
}
