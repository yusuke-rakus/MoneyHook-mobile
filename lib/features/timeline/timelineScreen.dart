import 'package:flutter/material.dart';
import 'package:money_hooks/class/response/timelineTransaction.dart';
import 'package:money_hooks/class/transactionClass.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/appBarMonth.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/customFloatingActionButtonLocation.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/features/timeline/calendar/timelineCalendar.dart';
import 'package:money_hooks/features/timeline/chart/timelineChart.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionApi.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionLoad.dart';
import 'package:money_hooks/features/timeline/timelineList.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final EnvClass env;

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late EnvClass env;
  late TimelineTransaction timelineList = TimelineTransaction();
  late List<TransactionClass> timelineChart = [];
  late bool _isLoading;
  late bool timelineMode = true;

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  void setTimelineData(List<TransactionClass> responseList) {
    setState(() => timelineList = TimelineTransaction.init(responseList));
  }

  void setTimelineChart(List<TransactionClass> responseList) {
    setState(() => timelineChart = responseList);
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    // env.initMonth();
    _isLoading = widget.isLoading;
    Future(() async {
      await TimelineTransactionLoad.getTimelineData(
          env, setLoading, setSnackBar, setTimelineData);
      await TimelineTransactionLoad.getTimelineChart(env, setTimelineChart);
    });
  }

  void setReload() {
    TimelineTransactionApi.getTimelineData(
        env, setLoading, setSnackBar, setTimelineData);
    TimelineTransactionApi.getTimelineChart(env, setTimelineChart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientBar(),
        title: CenterWidget(
          child: AppBarMonth(
            subtractMonth: () {
              env.subtractMonth();
              Future(() async {
                await TimelineTransactionLoad.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                await TimelineTransactionLoad.getTimelineChart(
                    env, setTimelineChart);
              });
            },
            addMonth: () {
              env.addMonth();
              Future(() async {
                await TimelineTransactionLoad.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                await TimelineTransactionLoad.getTimelineChart(
                    env, setTimelineChart);
              });
            },
            env: env,
          ),
        ),
      ),
      body: timelineMode
          ? RefreshIndicator(
              color: Colors.grey,
              onRefresh: () async {
                TimelineTransactionApi.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                TimelineTransactionApi.getTimelineChart(env, setTimelineChart);
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
                TimelineTransactionApi.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                TimelineTransactionApi.getTimelineChart(env, setTimelineChart);
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
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
    );
  }
}
