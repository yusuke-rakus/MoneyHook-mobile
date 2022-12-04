import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/response/timelineTransaction.dart';
import 'package:money_hooks/src/components/charts/timelineChart.dart';
import 'package:money_hooks/src/components/timelineList.dart';

import '../class/transactionClass.dart';
import '../env/env.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late envClass env;
  late timelineTransaction timelineList;

  @override
  void initState() {
    super.initState();
    env = envClass();
    timelineList = timelineTransaction([
      transactionClass.setTimelineFields(
          '1', '2022-11-01', -1, '1000', 'スーパーアルプス1', '食費'),
      transactionClass.setTimelineFields(
          '2', '2022-11-18', -1, '1000', 'スーパーアルプス2', '食費'),
      transactionClass.setTimelineFields(
          '3', '2022-11-25', -1, '1000', 'スーパーアルプス3', '食費'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    env.subtractMonth();
                    timelineList.transactionList.clear();
                  });
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text('${env.getMonth()}月'),
            IconButton(
                onPressed: () {
                  setState(() {
                    env.addMonth();
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 200,
            child: TimelineChart(),
          ),
          TimelineList(
            env: env,
            timelineList: timelineList.transactionList,
          ),
        ],
      ),
    );
  }
}
