import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../class/monthlyTransactionClass.dart';
import '../class/response/timelineTransaction.dart';
import '../components/commonLoadingAnimation.dart';
import '../components/customFloatingButtonLocation.dart';
import '../components/dataNotRegisteredBox.dart';
import '../components/timelineList.dart';
import '../dataLoader/monthlyTransactionLoad.dart';
import '../env/envClass.dart';

class TimelineCalendar extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final bool isLoading;
  final envClass env;
  final Function setReload;
  final TimelineTransaction timelines;

  const TimelineCalendar({
    Key? key,
    required this.onRefresh,
    required this.isLoading,
    required this.env,
    required this.setReload,
    required this.timelines,
  }) : super(key: key);

  @override
  State<TimelineCalendar> createState() => _TimelineCalendarState();
}

class _TimelineCalendarState extends State<TimelineCalendar> {
  DateTime? selectedDate;
  List<TransactionClass> transactions = [];
  late List<MonthlyTransactionClass> monthlyTransactionList = [];
  late bool _isLoading;

  (num, num) _getSumForDate(DateTime day) {
    String today = DateFormat('yyyy-MM-dd').format(day);

    num spendSum = 0;
    num incomeSum = 0;
    widget.timelines.transactionList.forEach((value) {
      if (today == value.transactionDate) {
        spendSum += value.transactionSign == -1 ? value.transactionAmount : 0;
        incomeSum += value.transactionSign == 1 ? value.transactionAmount : 0;
      }
    });
    return (spendSum, incomeSum);
  }

  List<TransactionClass> _getTransactionForDate(DateTime day) {
    String today = DateFormat('yyyy-MM-dd').format(day);
    List<TransactionClass> resultList = [];

    widget.timelines.transactionList.forEach((value) {
      if (today == value.transactionDate) {
        resultList.add(value);
      }
    });
    return resultList;
  }

  void setMonthlyTransactionList(List<MonthlyTransactionClass> resultList) {
    setState(() {
      monthlyTransactionList = resultList;
    });
  }

  (num, num) _selectMonthlyTransaction(DateTime date) {
    DateTime lastDate = widget.env.getLastDayOfMonth();

    num spendSum = 0;
    num incomeSum = 0;
    monthlyTransactionList.forEach((value) {
      // 今月の予定を集計する
      if (lastDate.month == date.month) {
        if (lastDate.day == date.day &&
            value.monthlyTransactionDate >= lastDate.day) {
          spendSum += value.monthlyTransactionSign == -1
              ? value.monthlyTransactionAmount
              : 0;
          incomeSum += value.monthlyTransactionSign == 1
              ? value.monthlyTransactionAmount
              : 0;
        } else if (value.monthlyTransactionDate == date.day) {
          spendSum += value.monthlyTransactionSign == -1
              ? value.monthlyTransactionAmount
              : 0;
          incomeSum += value.monthlyTransactionSign == 1
              ? value.monthlyTransactionAmount
              : 0;
        }
      }
    });
    return (spendSum, incomeSum);
  }

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

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    MonthlyTransactionLoad.getFixed(
        widget.env, setMonthlyTransactionList, setLoading, setSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CenterWidget(child: CommonLoadingAnimation.build())
        : ListView(
            shrinkWrap: true,
            children: [
              CenterWidget(
                maxWidth: 1000,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TableCalendar(
                      firstDay: widget.env.getDateTimeMonth(),
                      focusedDay: widget.env.getDateTimeMonth(),
                      lastDay: DateTime.now().month ==
                              widget.env.getDateTimeMonth().month
                          ? DateTime.now()
                          : widget.env.getLastDayOfMonth(),
                      availableGestures: AvailableGestures.none,
                      daysOfWeekVisible: false,
                      headerVisible: false,
                      rowHeight: 100,
                      currentDay: DateTime.now(),
                      onDaySelected: ((selectedDay, focusedDay) {
                        setState(() {
                          selectedDate = selectedDay;
                          transactions = _getTransactionForDate(selectedDay);
                        });
                      }),
                      calendarBuilders: CalendarBuilders(
                        todayBuilder: (context, date, focusedDay) {
                          final (spendSum, incomeSum) = _getSumForDate(date);
                          String fmtSpendSum = spendSum != 0
                              ? "¥${TransactionClass.formatNum(spendSum.toInt())}"
                              : "";
                          String fmtIncomeSum = incomeSum != 0
                              ? "¥${TransactionClass.formatNum(incomeSum.toInt())}"
                              : "";
                          return _buildContainer(
                              date, fmtSpendSum, fmtIncomeSum,
                              isToday: true);
                        },
                        defaultBuilder: (context, date, focusedDay) {
                          final (spendSum, incomeSum) = _getSumForDate(date);
                          String fmtSpendSum = spendSum != 0
                              ? "¥${TransactionClass.formatNum(spendSum.toInt())}"
                              : "";
                          String fmtIncomeSum = incomeSum != 0
                              ? "¥${TransactionClass.formatNum(incomeSum.toInt())}"
                              : "";
                          return _buildContainer(
                              date, fmtSpendSum, fmtIncomeSum);
                        },
                        outsideBuilder: (context, date, focusedDay) {
                          final (spendSum, incomeSum) = _getSumForDate(date);
                          String fmtSpendSum = spendSum != 0
                              ? "¥${TransactionClass.formatNum(spendSum.toInt())}"
                              : "";
                          String fmtIncomeSum = incomeSum != 0
                              ? "¥${TransactionClass.formatNum(incomeSum.toInt())}"
                              : "";
                          return _buildContainer(
                              date, fmtSpendSum, fmtIncomeSum,
                              enable: false);
                        },
                        disabledBuilder: (context, date, focusedDay) {
                          final (spendSum, incomeSum) = _getSumForDate(date);
                          final (mtSpendSum, mtIncomeSum) =
                              _selectMonthlyTransaction(date);
                          String fmtSpendSum = spendSum != 0 || mtSpendSum != 0
                              ? "¥${TransactionClass.formatNum(spendSum.toInt() + mtSpendSum.toInt())}"
                              : "";
                          String fmtIncomeSum = incomeSum != 0 ||
                                  mtIncomeSum != 0
                              ? "¥${TransactionClass.formatNum(incomeSum.toInt() + mtIncomeSum.toInt())}"
                              : "";
                          return _buildContainer(
                              date, fmtSpendSum, fmtIncomeSum,
                              enable: false);
                        },
                      )),
                ),
              ),
              CenterWidget(
                  child: selectedDate != null
                      ? TimelineList(
                          env: widget.env,
                          timelineList: transactions,
                          setReload: widget.setReload)
                      : const dataNotRegisteredBox(message: '日付を選択してください')),
              const SizedBox(height: 100)
            ],
          );
  }

  Widget _buildContainer(DateTime date, String fmtSpendSum, String fmtIncomeSum,
      {bool isToday = false, bool enable = true}) {
    Color circleColor = Colors.transparent;
    if (isToday) {
      circleColor = Colors.lightBlue;
    } else if (selectedDate == date) {
      circleColor = const Color(0xFF4FC3F7);
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.05),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
              ),
              child: Text(
                date.day.toString(),
                style: TextStyle(
                    fontSize: 16,
                    color: circleColor != Colors.transparent
                        ? Colors.white
                        : enable
                            ? null
                            : Colors.grey),
              ),
            ),
            fmtSpendSum != ""
                ? Padding(
                    padding: const EdgeInsets.only(left: 3.5, right: 3.5),
                    child: FittedBox(
                        child: Text(fmtSpendSum,
                            style: TextStyle(
                                color: enable
                                    ? const Color(0xFFB71C1C)
                                    : const Color(0xFFEF9A9A)))),
                  )
                : const SizedBox(),
            fmtIncomeSum != ""
                ? Padding(
                    padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                    child: FittedBox(
                        child: Text(fmtIncomeSum,
                            style: TextStyle(
                                color: enable
                                    ? const Color(0xFF1B5E20)
                                    : const Color(0xFF81C784)))),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
