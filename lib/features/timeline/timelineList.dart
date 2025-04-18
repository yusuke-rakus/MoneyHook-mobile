import 'package:flutter/material.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/dataNotRegisteredBox.dart';
import 'package:money_hooks/features/editTransaction/editTransaction.dart';

class TimelineList extends StatelessWidget {
  const TimelineList(
      {super.key,
      required this.env,
      required this.timelineList,
      required this.setReload});

  final EnvClass env;
  final List<TransactionClass> timelineList;
  final Function setReload;

  @override
  Widget build(BuildContext context) {
    return timelineList.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            itemCount: timelineList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  // タップ処理
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTransaction(
                              timelineList[index], env, setReload),
                          fullscreenDialog: true),
                    );
                  },
                  child: SizedBox(
                    height: 35,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${timelineList[index].getDay()}日',
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            timelineList[index].categoryName,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            timelineList[index].transactionName,
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '¥${TransactionClass.formatNum(timelineList[index].transactionAmount.toInt())}',
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Expanded(
                            flex: 1, child: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  ));
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          )
        : const DataNotRegisteredBox(message: '取引履歴が存在しません');
  }
}
