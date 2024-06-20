import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:table_calendar/table_calendar.dart';

import '../class/response/timelineTransaction.dart';
import '../components/dataNotRegisteredBox.dart';
import '../components/timelineList.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TableCalendar(
              // firstDay: DateTime(DateTime.now().year - 1),
              firstDay: widget.env.getDateTimeMonth(),
              focusedDay: widget.env.getDateTimeMonth(),
              lastDay: DateTime.now(),
              daysOfWeekVisible: false,
              headerVisible: false,
              rowHeight: 110,
              currentDay: DateTime.now(),
              // 今日の修正
              onPageChanged: ((focusedDay) {
                setState(() {
                  widget.env.setMonth(focusedDay);
                });
              }),
              // 今日の修正
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
                  return _buildContainer(date, fmtSpendSum, fmtIncomeSum,
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
                  return _buildContainer(date, fmtSpendSum, fmtIncomeSum);
                },
                outsideBuilder: (context, date, focusedDay) {
                  final (spendSum, incomeSum) = _getSumForDate(date);
                  String fmtSpendSum = spendSum != 0
                      ? "¥${TransactionClass.formatNum(spendSum.toInt())}"
                      : "";
                  String fmtIncomeSum = incomeSum != 0
                      ? "¥${TransactionClass.formatNum(incomeSum.toInt())}"
                      : "";
                  return _buildContainer(date, fmtSpendSum, fmtIncomeSum,
                      enable: false);
                },
                disabledBuilder: (context, date, focusedDay) {
                  final (spendSum, incomeSum) = _getSumForDate(date);
                  String fmtSpendSum = spendSum != 0
                      ? "¥${TransactionClass.formatNum(spendSum.toInt())}"
                      : "";
                  String fmtIncomeSum = incomeSum != 0
                      ? "¥${TransactionClass.formatNum(incomeSum.toInt())}"
                      : "";
                  return _buildContainer(date, fmtSpendSum, fmtIncomeSum,
                      enable: false);
                },
              )),
        ),
        Center(
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
            Text(fmtSpendSum, style: const TextStyle(color: Colors.red)),
            Text(fmtIncomeSum, style: const TextStyle(color: Colors.green))
          ],
        ),
      ),
    );
  }
}