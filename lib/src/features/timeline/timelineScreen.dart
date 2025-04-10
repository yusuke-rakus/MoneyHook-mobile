import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/timelineTransaction.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/common/env/envClass.dart';
import 'package:money_hooks/src/common/widgets/appBarMonth.dart';
import 'package:money_hooks/src/common/widgets/centerWidget.dart';
import 'package:money_hooks/src/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/src/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/src/common/widgets/customFloatingActionButtonLocation.dart';
import 'package:money_hooks/src/common/widgets/gradientBar.dart';
import 'package:money_hooks/src/dataLoader/transactionLoad.dart';
import 'package:money_hooks/src/features/timeline/calendar/timelineCalendar.dart';
import 'package:money_hooks/src/features/timeline/chart/timelineChart.dart';
import 'package:money_hooks/src/features/timeline/timelineList.dart';

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
      await TransactionLoad.getTimelineData(
          env, setLoading, setSnackBar, setTimelineData);
      await TransactionLoad.getTimelineChart(env, setTimelineChart);
    });
  }

  void setReload() {
    TransactionApi.getTimelineData(
        env, setLoading, setSnackBar, setTimelineData);
    TransactionApi.getTimelineChart(env, setTimelineChart);
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
                await TransactionLoad.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                await TransactionLoad.getTimelineChart(env, setTimelineChart);
              });
            },
            addMonth: () {
              env.addMonth();
              Future(() async {
                await TransactionLoad.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                await TransactionLoad.getTimelineChart(env, setTimelineChart);
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
                TransactionApi.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                TransactionApi.getTimelineChart(env, setTimelineChart);
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
                TransactionApi.getTimelineData(
                    env, setLoading, setSnackBar, setTimelineData);
                TransactionApi.getTimelineChart(env, setTimelineChart);
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
