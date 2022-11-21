import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/class/savingClass.dart';

class EditSaving extends StatefulWidget {
  EditSaving(this.saving, {super.key});

  savingClass saving;

  @override
  State<EditSaving> createState() => _EditSaving();
}

class _EditSaving extends State<EditSaving> {
  late savingClass saving;

  @override
  void initState() {
    super.initState();
    saving = widget.saving;
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
                child: Container(
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
                            saving.savingAmount = value;
                          },
                          controller: TextEditingController(
                              text: saving.savingAmount),
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
              Container(
                color: Colors.red,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 40, right: 40),
                height: 100,
                child: const Text('貯金目標選択'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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
