import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/timelineTransaction.dart';
import 'package:money_hooks/src/components/charts/timelineChart.dart';
import 'package:money_hooks/src/components/timelineList.dart';

import '../class/transactionClass.dart';
import '../components/commonLoadingAnimation.dart';
import '../dataLoader/transactionLoad.dart';
import '../env/envClass.dart';

class TimelineScreen extends StatefulWidget {
  TimelineScreen(this.isLoading, this.env, {super.key});

  bool isLoading;
  envClass env;

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
    env = widget.env;
    env.initMonth();
    _isLoading = widget.isLoading;
    transactionLoad.getTimelineData(env, setLoading, setTimelineData);
    transactionLoad.getTimelineChart(env, setTimelineChart);
  }

  void setReload() {
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
                    transactionLoad.getTimelineData(
                        env, setLoading, setTimelineData);
                    transactionLoad.getTimelineChart(env, setTimelineChart);
                  });
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text('${env.getMonth()}月'),
            IconButton(
                onPressed: () {
                  setState(() {
                    // 翌月が未来でなければデータ取得
                    if (env.isNotCurrentMonth()) {
                      env.addMonth();
                      transactionLoad.getTimelineData(
                          env, setLoading, setTimelineData);
                      transactionLoad.getTimelineChart(env, setTimelineChart);
                    }
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: Colors.grey,
        onRefresh: () async {
          transactionApi.getTimelineData(env, setLoading, setTimelineData);
          transactionApi.getTimelineChart(env, setTimelineChart);
        },
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: TimelineChart(timelineChart),
            ),
            Center(
              child: _isLoading
                  ? CommonLoadingAnimation.build()
                  : TimelineList(
                      env: env,
                      timelineList: timelineList.transactionList,
                      setReload: setReload),
            ),
          ],
        ),
      ),
    );
  }
}
