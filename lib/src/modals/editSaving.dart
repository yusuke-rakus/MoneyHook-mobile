import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/dataLoader/savingTargetLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../components/commonLoadingDialog.dart';
import '../components/commonSnackBar.dart';
import '../components/deleteConfirmDialog.dart';

class EditSaving extends StatefulWidget {
  const EditSaving(this.saving, this.env, this.setReload, {super.key});

  final SavingClass saving;
  final envClass env;
  final Function setReload;

  @override
  State<EditSaving> createState() => _EditSaving();
}

class _EditSaving extends State<EditSaving> {
  late SavingClass saving;
  late envClass env;
  late List<String> recommendList = [];
  late List<SavingTargetClass> savingTargetList = [];

  final TextEditingController nameController = TextEditingController();

  void setSavingTargetList(List<SavingTargetClass> responseList) {
    setState(() {
      savingTargetList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    saving = widget.saving;
    env = widget.env;

    nameController.value =
        nameController.value.copyWith(text: saving.savingName);
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    Future(() async {
      await SavingTargetLoad.getSavingTargetList(
          setSavingTargetList, env.userId);
      if (!saving.hasSavingId()) {
        await SavingApi.getFrequentSavingName(env, setRecommendList);
      }
    });
  }

  void backNavigation() {
    widget.setReload();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  // 取引候補
  void setRecommendList(List<String> resultList) {
    setState(() {
      recommendList = resultList;
    });
  }

  // 貯金編集
  void _editSaving(SavingClass saving, envClass env) {
    commonLoadingDialog(context: context);
    saving.userId = env.userId;
    if (saving.hasSavingId()) {
      // 編集
      SavingApi.editSaving(saving, backNavigation, setDisable, setSnackBar);
    } else {
      // 新規追加
      SavingApi.addSaving(saving, backNavigation, setDisable, setSnackBar);
    }
  }

  // 貯金削除
  void _deleteSaving(envClass env, SavingClass saving) {
    commonLoadingDialog(context: context);
    SavingApi.deleteSaving(
        env, saving, backNavigation, setDisable, setSnackBar);
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  // ボタン非表示処理
  void setDisable() {
    setState(() {
      saving.isDisable = !saving.isDisable;
      if (!saving.isDisable) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final amountController = TextEditingController(
        text: saving.savingAmount != 0
            ? SavingClass.formatNum(saving.savingAmount.toInt())
            : '');
    amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length));

    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          appBar: AppBar(
            title: saving.hasSavingId()
                ? const Text('貯金の編集')
                : const Text('貯金の追加'),
            actions: [
              // 削除アイコン
              Visibility(
                visible: saving.hasSavingId(),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: saving.isDisabled()
                          ? null
                          : () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      deleteConfirmDialog(
                                          context: context,
                                          title: '貯金を削除しますか',
                                          leftText: 'キャンセル',
                                          rightText: '削除',
                                          isDestructiveAction: true,
                                          function: () {
                                            // 削除処理
                                            Navigator.pop(context);
                                            _deleteSaving(env, saving);
                                          }));
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
                                .parse(saving.savingDate),
                            onDateTimeChanged: (value) {
                              setState(() {
                                saving.savingDate =
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
                            '${saving.savingDate.replaceAll('-', '月').replaceFirst('月', '年')}日',
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
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  if (value.isNotEmpty) {
                                    saving.savingAmount =
                                        SavingClass.formatInt(value);
                                  } else {
                                    saving.savingAmount = 0;
                                  }
                                });
                              },
                              controller: amountController,
                              decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: const TextStyle(
                                      fontSize: 20, letterSpacing: 8),
                                  errorText: saving.savingAmountError.isNotEmpty
                                      ? saving.savingAmountError
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
                  // 貯金名
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    height: 100,
                    alignment: Alignment.center,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          saving.savingName = value;
                        });
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: '貯金名',
                          errorText: saving.savingNameError.isNotEmpty
                              ? saving.savingNameError
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
                              (savingName) => Container(
                                height: 23,
                                margin: const EdgeInsets.only(top: 3, right: 5),
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      nameController.text = savingName;
                                      saving.savingName = savingName;
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
                                  child: Text(savingName),
                                ),
                              ),
                            )
                            .toList()),
                  ),
                  // 貯金目標
                  Visibility(
                    visible: savingTargetList.isNotEmpty,
                    child: Container(
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(30, 30, 40, 30),
                      child: InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  diameterRatio: 1.0,
                                  itemExtent: 30.0,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: savingTargetList
                                          .map((e) => e.savingTargetId)
                                          .toList()
                                          .indexOf(
                                              saving.savingTargetId?.toInt())),
                                  onSelectedItemChanged: (int i) {
                                    setState(() {
                                      // 貯金目標をセット
                                      saving.savingTargetName =
                                          savingTargetList[i].savingTargetName;
                                      saving.savingTargetId =
                                          savingTargetList[i].savingTargetId;
                                    });
                                  },
                                  children: savingTargetList
                                      .map((e) => Text(e.savingTargetName))
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          height: 70,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '振り分ける',
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    saving.hasTargetId()
                                        ? 'なし'
                                        : saving.savingTargetName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 登録ボタン
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white,
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saving.isDisabled()
                          ? null
                          : () {
                              setState(() {
                                _editSaving(saving, env);
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
            ],
          ),
        ),
      ),
    );
  }
}
