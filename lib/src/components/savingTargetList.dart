import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/env/env.dart';

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
        return Card(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              debugPrint('Card tapped.');
            },
            child: SizedBox(
              width: 300,
              height: 100,
              child: Text(savingTargetList[index].savingTargetName),
            ),
          ),
        );
      },
    );
  }
}
