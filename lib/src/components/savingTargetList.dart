import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

class SavingTargetList extends StatelessWidget {
  const SavingTargetList(
      {Key? key, required this.env, required this.savingTargetList})
      : super(key: key);
  final envClass env;
  final List<savingTargetClass> savingTargetList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: savingTargetList.length,
      itemBuilder: (BuildContext context, int index) {
        return _savingTargetCard(savingTargetList[index]);
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
          debugPrint('Card tapped.');
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
                  child: Text(savingTarget.savingTargetName)),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultTextStyle(
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(),
                          1: IntrinsicColumnWidth(),
                          2: FixedColumnWidth(10),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.top,
                        children: [
                          TableRow(children: [
                            const Text('目標'),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(savingTarget.targetAmount.toString()),
                            ),
                            const Text('円'),
                          ]),
                          TableRow(children: [
                            const Text('貯金回数'),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(savingTarget.savingCount.toString()),
                            ),
                            const Text('回'),
                          ]),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Text('貯金額'),
                        Text(
                          '¥${savingTarget.savingTotalAmount}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
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
