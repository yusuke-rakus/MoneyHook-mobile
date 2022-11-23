import "package:flutter/material.dart";
import 'package:money_hooks/src/components/monthHeader.dart';
import 'package:money_hooks/src/components/timelineList.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const MonthHeader(),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
                  color: Colors.cyan,
                  height: 180,
                  width: double.infinity,
                  child: const Center(child: Text('グラフ'))),
              const Flexible(
                child: TimelineList(),
              )
            ],
          ),
        ));
  }
}
