import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/savingTargetApi.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../modals/editSavingTarget.dart';
import 'commonSnackBar.dart';

class SavingTargetList extends StatefulWidget {
  const SavingTargetList(
      {Key? key,
      required this.context,
      required this.env,
      required this.savingTargetList,
      required this.setReload})
      : super(key: key);
  final BuildContext context;
  final envClass env;
  final List<savingTargetClass> savingTargetList;
  final Function setReload;

  @override
  State<SavingTargetList> createState() => _SavingTargetListState();
}

class _SavingTargetListState extends State<SavingTargetList> {
  late List<savingTargetClass> savingTargetList;
  late envClass env;
  late Function setReload;

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  @override
  void initState() {
    super.initState();
    savingTargetList = widget.savingTargetList;
    env = widget.env;
    setReload = widget.setReload;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: savingTargetList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            key: Key('$index'),
            title: _savingTargetCard(savingTargetList[index]));
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final savingTargetClass savingTarget =
            savingTargetList.removeAt(oldIndex);
        setState(() {
          savingTargetList.insert(newIndex, savingTarget);
          savingTargetList.asMap().forEach((i, e) {
            e.sortNo = i + 1;
          });
        });
        // API通信
        SavingTargetApi.sortSavingTarget(env, savingTargetList, setSnackBar);
      },
    );
  }

  // 貯金目標カード
  Widget _savingTargetCard(savingTargetClass savingTarget) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditSavingTarget(savingTarget, env, setReload),
                fullscreenDialog: true),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black26))),
                  // 貯金目標名称
                  child: Text(
                    savingTarget.savingTargetName,
                    overflow: TextOverflow.ellipsis,
                  )),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    // 目標・貯金回数
                    Expanded(
                      flex: 6,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                        child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: IntrinsicColumnWidth(),
                            2: IntrinsicColumnWidth()
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.top,
                          children: [
                            // 目標額
                            TableRow(children: [
                              const Text('目標'),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  savingTargetClass.formatNum(
                                      savingTarget.targetAmount.toInt()),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Text('円'),
                            ]),
                            // 貯金回数
                            TableRow(children: [
                              const Text('貯金回数'),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  savingTarget.savingCount.toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Text('回'),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // 貯金額
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Center(child: Text('貯金額')),
                          Text(
                            '¥${savingTargetClass.formatNum(savingTarget.savingTotalAmount.toInt())}',
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
