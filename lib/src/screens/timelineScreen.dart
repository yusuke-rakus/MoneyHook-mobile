import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/timelineTransaction.dart';
import 'package:money_hooks/src/components/charts/timelineChart.dart';
import 'package:money_hooks/src/components/gradientBar.dart';
import 'package:money_hooks/src/components/timelineList.dart';

import '../class/transactionClass.dart';
import '../components/commonLoadingAnimation.dart';
import '../components/commonSnackBar.dart';
import '../dataLoader/transactionLoad.dart';
import '../env/envClass.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final envClass env;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late envClass env;
  late TimelineTransaction timelineList = TimelineTransaction();
  late List<TransactionClass> timelineChart = [];
  late bool _isLoading;

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  void setTimelineData(List<TransactionClass> responseList) {
    setState(() {
      timelineList = TimelineTransaction.init(responseList);
    });
  }

  void setTimelineChart(List<TransactionClass> responseList) {
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
    Future(() async {
      await TransactionLoad.getTimelineData(
          env, setLoading, setSnackBar, setTimelineData);
      await TransactionLoad.getTimelineChart(env, setTimelineChart);
    });
  }

  void setReload() {
    transactionApi.getTimelineData(
        env, setLoading, setSnackBar, setTimelineData);
    transactionApi.getTimelineChart(env, setTimelineChart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientBar(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    env.subtractMonth();
                    Future(() async {
                      await TransactionLoad.getTimelineData(
                          env, setLoading, setSnackBar, setTimelineData);
                      await TransactionLoad.getTimelineChart(
                          env, setTimelineChart);
                    });
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
                      Future(() async {
                        await TransactionLoad.getTimelineData(
                            env, setLoading, setSnackBar, setTimelineData);
                        await TransactionLoad.getTimelineChart(
                            env, setTimelineChart);
                      });
                    }
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 800,
          child: RefreshIndicator(
            color: Colors.grey,
            onRefresh: () async {
              transactionApi.getTimelineData(
                  env, setLoading, setSnackBar, setTimelineData);
              transactionApi.getTimelineChart(env, setTimelineChart);
            },
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 180,
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
        ),
      ),
    );
  }
}
