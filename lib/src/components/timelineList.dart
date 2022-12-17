import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

class TimelineList extends StatelessWidget {
  const TimelineList({Key? key, required this.env, required this.timelineList})
      : super(key: key);
  final envClass env;
  final List<transactionClass> timelineList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: timelineList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              print(timelineList[index].transactionId.toString());
              print(env.thisMonth);
            },
            child: SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${timelineList[index].getDay()}日',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    timelineList[index].categoryName,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    timelineList[index].transactionName,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    '¥${timelineList[index].transactionAmount.toString()}',
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
