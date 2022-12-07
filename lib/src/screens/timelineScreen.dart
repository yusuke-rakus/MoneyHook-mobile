import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/timelineTransaction.dart';
import 'package:money_hooks/src/components/charts/timelineChart.dart';
import 'package:money_hooks/src/components/timelineList.dart';

import '../class/transactionClass.dart';
import '../env/env.dart';

class TimelineScreen extends StatefulWidget {
  TimelineScreen(this.isLoading, {super.key});

  bool isLoading;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late envClass env;
  late timelineTransaction timelineList = timelineTransaction();
  late List<transactionClass> timelineChart = [];
  late bool _isLoading;

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void setTimelineData(List<transactionClass> responseList) {
    setState(() {
      timelineList = timelineTransaction.init(responseList);
    });
  }

  void setTimelineChart(List<transactionClass> responseList) {
    setState(() {
      timelineChart = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = envClass();
    _isLoading = widget.isLoading;
    transactionApi.getTimelineData(env, setLoading, setTimelineData);
    transactionApi.getTimelineChart(env, setTimelineChart);
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
                    transactionApi.getTimelineData(
                        env, setLoading, setTimelineData);
                    transactionApi.getTimelineChart(env, setTimelineChart);
                  });
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text('${env.getMonth()}月'),
            IconButton(
                onPressed: () {
                  setState(() {
                    env.addMonth();
                    transactionApi.getTimelineData(
                        env, setLoading, setTimelineData);
                    transactionApi.getTimelineChart(env, setTimelineChart);
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: TimelineChart(timelineChart),
          ),
          Center(
            child: _isLoading
                ? LoadingAnimationWidget.staggeredDotsWave(
                    color: const Color(0xFF76D5FF), size: 50)
                : TimelineList(
                    env: env,
                    timelineList: timelineList.transactionList,
                  ),
          ),
        ],
      ),
    );
  }
}
