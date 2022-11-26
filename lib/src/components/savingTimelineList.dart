import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/env/env.dart';

class SavingTimelineList extends StatelessWidget {
  const SavingTimelineList(
      {Key? key, required this.env, required this.savingTimelineList})
      : super(key: key);
  final envClass env;
  final List<savingClass> savingTimelineList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: savingTimelineList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              // print(savingTimelineList[index]);
              print(env.thisMonth);
            },
            child: SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${savingTimelineList[index].getDay()}日',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    savingTimelineList[index].savingName,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    '¥${savingTimelineList[index].savingAmount}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
