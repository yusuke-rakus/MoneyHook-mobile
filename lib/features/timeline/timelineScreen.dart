import 'package:flutter/material.dart';
import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/appBarMonth.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/customFloatingActionButtonLocation.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/features/timeline/calendar/timelineCalendar.dart';
import 'package:money_hooks/features/timeline/chart/timelineChart.dart';
import 'package:money_hooks/features/timeline/class/sortType.dart';
import 'package:money_hooks/features/timeline/class/timelineTransaction.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionApi.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionLoad.dart';
import 'package:money_hooks/features/timeline/filterWidget.dart';
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
  List<SortType> sortTypes = SortType.values;
  SortType sortType = SortType.values.first;
  late List<CategoryClass> categoryList = [];
  CategoryClass? filterCategory;

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  void setTimelineData(List<TransactionClass> responseList) {
    setState(() {
      timelineList = TimelineTransaction.init(responseList);
      timelineList.transactionList =
          sortTimelineList(sortType, timelineList.transactionList);
    });
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
      setTimelineData(await TimelineTransactionLoad.getTimelineData(
          env, setLoading, setSnackBar));
      setTimelineChart(await TimelineTransactionLoad.getTimelineChart(env));
    });
  }

  void setReload() async {
    setTimelineData(await TimelineTransactionApi.getTimelineData(
        env, setLoading, setSnackBar));
    setTimelineChart(await TimelineTransactionApi.getTimelineChart(env));
  }

  List<TransactionClass> sortTimelineList(
      SortType sortType, List<TransactionClass> transactionList) {
    List<TransactionClass> newTransactionList;
    switch (sortType) {
      case SortType.dateDesc:
        newTransactionList = List.from(transactionList)
          ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
        break;
      case SortType.dateAsc:
        newTransactionList = List.from(transactionList)
          ..sort((a, b) => a.transactionDate.compareTo(b.transactionDate));
        break;
      case SortType.amountAsc:
        newTransactionList = List.from(transactionList)
          ..sort((a, b) => (b.transactionSign * b.transactionAmount)
              .compareTo(a.transactionSign * a.transactionAmount));
        break;
      case SortType.amountDesc:
        newTransactionList = List.from(transactionList)
          ..sort((a, b) => (a.transactionSign * a.transactionAmount)
              .compareTo(b.transactionSign * b.transactionAmount));
        break;
    }
    return newTransactionList;
  }

  Future<void> _filterTimeline(List<CategoryClass> filterCategories,
      List<PaymentResourceData> filterPayments) async {
    setTimelineData(await TimelineTransactionLoad.getTimelineData(
        env, setLoading, setSnackBar));

    List categoryIds =
        filterCategories.map((category) => category.categoryId).toList();
    List paymentIds =
        filterPayments.map((payment) => payment.paymentId).toList();

    List<TransactionClass> filteredTransactions = timelineList.transactionList
        .where((tran) => categoryIds.contains(tran.categoryId))
        .where((tran) => paymentIds.contains(tran.paymentId))
        .toList();

    setState(() {
      timelineList.transactionList = filteredTransactions;
    });
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
                setTimelineData(await TimelineTransactionLoad.getTimelineData(
                    env, setLoading, setSnackBar));
                setTimelineChart(
                    await TimelineTransactionLoad.getTimelineChart(env));
              });
            },
            addMonth: () {
              env.addMonth();
              Future(() async {
                setTimelineData(await TimelineTransactionLoad.getTimelineData(
                    env, setLoading, setSnackBar));
                setTimelineChart(
                    await TimelineTransactionLoad.getTimelineChart(env));
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
                setTimelineData(await TimelineTransactionApi.getTimelineData(
                    env, setLoading, setSnackBar));
                setTimelineChart(
                    await TimelineTransactionApi.getTimelineChart(env));
              },
              child: ListView(
                children: [
                  CenterWidget(
                    margin: const EdgeInsets.only(top: 40, bottom: 10),
                    height: 180,
                    child: TimelineChart(timelineChart),
                  ),
                  CenterWidget(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _isLoading
                            ? []
                            : [
                                Tooltip(
                                  message: "フィルタ",
                                  child: IconButton(
                                      onPressed: () async {
                                        final result = await showDialog<
                                            Map<String, dynamic>>(
                                          context: context,
                                          builder: (context) =>
                                              FilterWidget(env: env),
                                        );

                                        if (result != null) {
                                          _filterTimeline(
                                              result["filterCategories"],
                                              result["filterPayments"]);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.filter_list,
                                        color: Colors.grey[600],
                                      ),
                                      splashRadius: 20),
                                ),
                                SizedBox(width: 10),
                                DropdownButton(
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontFamily: DefaultTextStyle.of(context)
                                            .style
                                            .fontFamily),
                                    focusColor: Colors.transparent,
                                    value: sortType,
                                    items: sortTypes
                                        .map((SortType item) =>
                                            DropdownMenuItem(
                                                value: item,
                                                child: Text(item.label)))
                                        .toList(),
                                    onChanged: (SortType? value) {
                                      setState(() {
                                        sortType = value!;
                                        timelineList.transactionList =
                                            sortTimelineList(value,
                                                timelineList.transactionList);
                                      });
                                    }),
                              ],
                      )),
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
                setTimelineData(await TimelineTransactionApi.getTimelineData(
                    env, setLoading, setSnackBar));
                setTimelineChart(
                    await TimelineTransactionApi.getTimelineChart(env));
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
