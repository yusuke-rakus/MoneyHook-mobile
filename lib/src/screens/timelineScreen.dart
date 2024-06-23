import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/timelineTransaction.dart';
import 'package:money_hooks/src/components/gradientBar.dart';

import '../class/transactionClass.dart';
import '../components/centerWidget.dart';
import '../components/charts/timelineChart.dart';
import '../components/commonLoadingAnimation.dart';
import '../components/commonSnackBar.dart';
import '../components/timelineList.dart';
import '../dataLoader/transactionLoad.dart';
import '../env/envClass.dart';
import '../view/timelineCalendar.dart';

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
  late bool timelineMode = true;

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
        title: CenterWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Tooltip(
                message: "前の月",
                child: IconButton(
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
              ),
              Text('${env.getMonth()}月'),
              Tooltip(
                message: "次の月",
                child: IconButton(
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
              ),
            ],
          ),
        ),
      ),
      body: timelineMode
          ? RefreshIndicator(
              color: Colors.grey,
              onRefresh: () async {
                transactionApi.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                transactionApi.getTimelineChart(env, setTimelineChart);
              },
              child: ListView(
                children: [
                  CenterWidget(
                    margin: const EdgeInsets.only(top: 40, bottom: 10),
                    height: 180,
                    child: TimelineChart(timelineChart),
                  ),
                  CenterWidget(
                    child: _isLoading
                        ? CommonLoadingAnimation.build()
                        : TimelineList(
                            env: env,
                            timelineList: timelineList.transactionList,
                            setReload: setReload),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            )
          : TimelineCalendar(
              onRefresh: () async {
                transactionApi.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                transactionApi.getTimelineChart(env, setTimelineChart);
              },
              isLoading: _isLoading,
              env: env,
              setReload: setReload,
              timelines: timelineList,
            ),
      floatingActionButton: Tooltip(
        message: timelineMode ? "カレンダーで表示" : "リストを表示",
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              timelineMode = !timelineMode;
            });
          },
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF80D8FF),
                Color(0xFF2962FF),
              ],
            ).createShader(bounds),
            child: Icon(
                size: 25,
                timelineMode ? Icons.calendar_month : Icons.bar_chart_sharp),
          ),
        ),
      ),
    );
  }
}
