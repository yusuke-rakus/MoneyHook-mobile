import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/savingTargetApi.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';

class EditSaving extends StatefulWidget {
  EditSaving(this.saving, {super.key});

  savingClass saving;

  @override
  State<EditSaving> createState() => _EditSaving();
}

class _EditSaving extends State<EditSaving> {
  late savingClass saving;
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
    savingTargetApi.getSavingTargetList(setSavingTargetList);
    if (savingTargetList.isNotEmpty) {
      savingTargetList.insert(0, savingTargetClass.setTargetFields(null, 'なし'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: saving.hasSavingId() ? const Text('貯金の編集') : const Text('貯金の追加'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8),
            children: [
              // 削除アイコン
              Visibility(
                visible: saving.hasSavingId(),
                child: SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black54,
                        )),
                  ),
                ),
              ),
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
                              text: saving.savingAmount != null
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
                                      .indexOf(saving.savingTargetId)),
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
                                    ? saving.savingTargetName
                                    : 'なし',
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
                    print(saving);
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
