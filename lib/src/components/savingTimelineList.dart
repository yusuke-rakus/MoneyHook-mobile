import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../modals/editSaving.dart';

class SavingTimelineList extends StatelessWidget {
  const SavingTimelineList(
      {Key? key,
      required this.env,
      required this.savingTimelineList,
      required this.setReload})
      : super(key: key);
  final envClass env;
  final List<SavingClass> savingTimelineList;
  final Function setReload;

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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditSaving(savingTimelineList[index], env, setReload),
                    fullscreenDialog: true),
              );
            },
            child: SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${savingTimelineList[index].getDay()}日',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        savingTimelineList[index].savingName,
                        style: const TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '¥${SavingClass.formatNum(savingTimelineList[index].savingAmount.toInt())}',
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios)),
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
