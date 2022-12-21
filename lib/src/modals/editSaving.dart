import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/api/savingTargetApi.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

class EditSaving extends StatefulWidget {
  EditSaving(this.saving, this.env, this.setReload, {super.key});

  savingClass saving;
  envClass env;
  Function setReload;

  @override
  State<EditSaving> createState() => _EditSaving();
}

class _EditSaving extends State<EditSaving> {
  late savingClass saving;
  late envClass env;
  late List<savingTargetClass> savingTargetList = [];

  void setSavingTargetList(List<savingTargetClass> responseList) {
    setState(() {
      savingTargetList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    saving = widget.saving;
    env = widget.env;
    savingTargetApi.getSavingTargetList(setSavingTargetList, env.userId);
  }

  void backNavigation() {
    widget.setReload();
    Navigator.pop(context);
  }

  void _editSaving(savingClass saving, envClass env) {
    saving.userId = env.userId;
    if (saving.hasSavingId()) {
      // 編集
      savingApi.editSaving(saving, backNavigation);
    } else {
      //  新規追加
      savingApi.addSaving(saving, backNavigation);
    }
  }

  void _deleteSaving(envClass env, savingClass saving) {
    savingApi.deleteSaving(env, saving, backNavigation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: saving.hasSavingId() ? const Text('貯金の編集') : const Text('貯金の追加'),
        actions: [
          // 削除アイコン
          Visibility(
            visible: saving.hasSavingId(),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              content: const Text('この貯金を削除します'),
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
                                    _deleteSaving(env, saving);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE53935),
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
                        initialDateTime:
                            DateFormat('yyyy-MM-dd').parse(saving.savingDate),
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
                            saving.savingAmount = int.parse(value);
                          },
                          controller: TextEditingController(
                              text: saving.savingAmount != 0
                                  ? saving.savingAmount.toString()
                                  : ''),
                          decoration: const InputDecoration(
                              hintText: '0',
                              hintStyle:
                                  TextStyle(fontSize: 20, letterSpacing: 8)),
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
                    saving.savingName = value;
                  },
                  controller: TextEditingController(text: saving.savingName),
                  decoration: const InputDecoration(labelText: '貯金名'),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              // 貯金目標
              Visibility(
                visible: savingTargetList.isNotEmpty,
                child: Container(
                  margin: const EdgeInsetsDirectional.fromSTEB(30, 30, 40, 30),
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
                                      .indexOf(saving.savingTargetId?.toInt())),
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
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _editSaving(saving, env);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
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
      ),
    );
  }
}
