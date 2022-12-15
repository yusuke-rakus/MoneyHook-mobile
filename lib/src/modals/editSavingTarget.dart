import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import '../class/savingTargetClass.dart';

class EditSavingTarget extends StatefulWidget {
  EditSavingTarget(this.savingTarget, {super.key});

  savingTargetClass savingTarget;

  @override
  State<EditSavingTarget> createState() => _EditSavingTarget();
}

class _EditSavingTarget extends State<EditSavingTarget> {
  late savingTargetClass savingTarget;

  @override
  void initState() {
    super.initState();
    savingTarget = widget.savingTarget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: savingTarget.hasTargetId()
              ? const Text('目標の編集')
              : const Text('目標の追加'),
        ),
        body: Stack(
          children: [
            ListView(padding: const EdgeInsets.all(8), children: [
              // 削除アイコン
              SizedBox(
                  height: 40,
                  child: Visibility(
                    visible: savingTarget.hasTargetId(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.black54,
                          )),
                    ),
                  )),
              // 目標名称
              Container(
                padding: const EdgeInsets.only(left: 40, right: 40),
                height: 150,
                alignment: Alignment.center,
                child: TextField(
                  onChanged: (value) {
                    savingTarget.savingTargetName = value;
                  },
                  controller: TextEditingController(
                      text: savingTarget.savingTargetName),
                  decoration: const InputDecoration(labelText: '目標名称'),
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
                            savingTarget.targetAmount = int.parse(value);
                          },
                          controller: TextEditingController(
                              text: savingTarget.targetAmount != null
                                  ? savingTarget.targetAmount.toString()
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
            ]),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print(savingTarget);
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
        ));
  }
}
