import 'package:flutter/material.dart';
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
  late List<transactionClass> timelineList;

  @override
  void initState() {
    super.initState();
    env = envClass();
    timelineList = [
      transactionClass.setTimelineFields(
          '1', '2022-11-01', -1, '1000', 'スーパーアルプス1', '食費'),
      transactionClass.setTimelineFields(
          '2', '2022-11-18', -1, '1000', 'スーパーアルプス2', '食費'),
      transactionClass.setTimelineFields(
          '3', '2022-11-25', -1, '1000', 'スーパーアルプス3', '食費'),
    ];
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
                      timelineList.clear();
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
        body: Center(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
                  color: Colors.cyan,
                  height: 180,
                  width: double.infinity,
                  child: const Center(child: Text('heh'))),
              Flexible(
                child: TimelineList(
                  env: env,
                  timelineList: timelineList,
                ),
              )
            ],
          ),
        ));
  }
}
