import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/class/monthlyTransactionClass.dart';
import 'package:money_hooks/class/response/timelineTransaction.dart';
import 'package:money_hooks/class/response/withdrawalData.dart';
import 'package:money_hooks/class/transactionClass.dart';
import 'package:money_hooks/common/data/data/monthlyTransaction/commonMonthlyTransactionLoad.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/dataNotRegisteredBox.dart';
import 'package:money_hooks/features/timeline/calendar/calendarTimelineListCard.dart';
import 'package:money_hooks/features/timeline/calendar/monthlyTransactionCard.dart';
import 'package:money_hooks/features/timeline/calendar/withdrawalListCard.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionLoad.dart';
import 'package:table_calendar/table_calendar.dart';

class TimelineCalendar extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final bool isLoading;
  final EnvClass env;
  final Function setReload;
  final TimelineTransaction timelines;

  const TimelineCalendar({
    super.key,
    required this.onRefresh,
    required this.isLoading,
    required this.env,
    required this.setReload,
    required this.timelines,
  });

  @override
  State<TimelineCalendar> createState() => _TimelineCalendarState();
}

class _TimelineCalendarState extends State<TimelineCalendar> {
  DateTime? selectedDate;
  List<TransactionClass> transactions = [];
  late List<MonthlyTransactionClass> monthlyTransactionList = [];
  late List<MonthlyTransactionClass> displayMonthlyTransactions = [];
  late List<WithdrawalData> withdrawalList = [];
  late List<WithdrawalData> displayWithdrawalList = [];
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
    setState(() => monthlyTransactionList = resultList);
  }

  void setWithdrawalList(List<WithdrawalData> resultList) {
    setState(() => withdrawalList = resultList);
  }

  (num, num, List<MonthlyTransactionClass>, List<WithdrawalData>)
      _selectMonthlyTransactionAmount(DateTime date) {
    DateTime lastDate = widget.env.getLastDayOfMonth();

    num spendSum = 0;
    num incomeSum = 0;
    List<MonthlyTransactionClass> monthlyTransactions = [];
    List<WithdrawalData> withdrawals = [];

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
          monthlyTransactions.add(value);
        } else if (value.monthlyTransactionDate == date.day) {
          spendSum += value.monthlyTransactionSign == -1
              ? value.monthlyTransactionAmount
              : 0;
          incomeSum += value.monthlyTransactionSign == 1
              ? value.monthlyTransactionAmount
              : 0;
          monthlyTransactions.add(value);
        }
      }
    });
    withdrawalList.forEach((value) {
      // 今月の予定を集計する
      if (lastDate.month == date.month) {
        if (lastDate.day == date.day && value.paymentDate >= lastDate.day) {
          spendSum += value.withdrawalAmount.abs();
          withdrawals.add(value);
        } else if (value.paymentDate == date.day) {
          spendSum += value.withdrawalAmount.abs();
          withdrawals.add(value);
        }
      }
    });
    return (spendSum, incomeSum, monthlyTransactions, withdrawals);
  }

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    CommonMonthlyTransactionLoad.getFixed(
        widget.env, setMonthlyTransactionList, setLoading, setSnackBar);
    Future(() async => await TimelineTransactionLoad.getMonthlyWithdrawalAmount(
        widget.env, setSnackBar, setWithdrawalList));
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
                          displayMonthlyTransactions = [];
                          displayWithdrawalList = [];
                          transactions = _getTransactionForDate(selectedDay);
                        });
                      }),
                      calendarBuilders: CalendarBuilders(
                        todayBuilder: (context, date, focusedDay) {
                          final (spendSum, incomeSum) = _getSumForDate(date);
                          String fmtSpendSum = spendSum != 0
                              ? '¥${TransactionClass.formatNum(spendSum.toInt())}'
                              : '';
                          String fmtIncomeSum = incomeSum != 0
                              ? '¥${TransactionClass.formatNum(incomeSum.toInt())}'
                              : '';
                          return _buildContainer(
                              date, fmtSpendSum, fmtIncomeSum,
                              isToday: true);
                        },
                        defaultBuilder: (context, date, focusedDay) {
                          final (spendSum, incomeSum) = _getSumForDate(date);
                          String fmtSpendSum = spendSum != 0
                              ? '¥${TransactionClass.formatNum(spendSum.toInt())}'
                              : '';
                          String fmtIncomeSum = incomeSum != 0
                              ? '¥${TransactionClass.formatNum(incomeSum.toInt())}'
                              : '';
                          return _buildContainer(
                              date, fmtSpendSum, fmtIncomeSum);
                        },
                        outsideBuilder: (context, date, focusedDay) {
                          final (spendSum, incomeSum) = _getSumForDate(date);
                          String fmtSpendSum = spendSum != 0
                              ? '¥${TransactionClass.formatNum(spendSum.toInt())}'
                              : '';
                          String fmtIncomeSum = incomeSum != 0
                              ? '¥${TransactionClass.formatNum(incomeSum.toInt())}'
                              : '';
                          return _buildContainer(
                              date, fmtSpendSum, fmtIncomeSum,
                              enable: false);
                        },
                        disabledBuilder: (context, date, focusedDay) {
                          final (
                            mtSpendSum,
                            mtIncomeSum,
                            monthlyTransactions,
                            withdrawals
                          ) = _selectMonthlyTransactionAmount(date);
                          String fmtSpendSum = mtSpendSum != 0
                              ? '¥${TransactionClass.formatNum(mtSpendSum.toInt())}'
                              : '';
                          String fmtIncomeSum = mtIncomeSum != 0
                              ? '¥${TransactionClass.formatNum(mtIncomeSum.toInt())}'
                              : '';
                          return GestureDetector(
                            onTap: () => setState(() {
                              selectedDate = date;
                              transactions = [];
                              displayMonthlyTransactions = monthlyTransactions;
                              displayWithdrawalList = withdrawals;
                            }),
                            child: _buildContainer(
                                date, fmtSpendSum, fmtIncomeSum,
                                enable: false),
                          );
                        },
                      )),
                ),
              ),
              CenterWidget(
                  child: selectedDate != null
                      ? _buildDetail()
                      : const DataNotRegisteredBox(message: '日付を選択してください')),
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
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: circleColor),
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
            fmtSpendSum != ''
                ? Padding(
                    padding: const EdgeInsets.only(left: 3.5, right: 3.5),
                    child: FittedBox(
                        child: Text(fmtSpendSum,
                            style: TextStyle(
                                color: enable
                                    ? const Color(0xFFB71C1C)
                                    : const Color(0xFFEF9A9A)))),
                  )
                : const Text(''),
            fmtIncomeSum != ''
                ? Padding(
                    padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                    child: FittedBox(
                        child: Text(fmtIncomeSum,
                            style: TextStyle(
                                color: enable
                                    ? const Color(0xFF1B5E20)
                                    : const Color(0xFF81C784)))),
                  )
                : const Text('')
          ],
        ),
      ),
    );
  }

  Widget _buildDetail() {
    return displayMonthlyTransactions.isNotEmpty ||
            displayWithdrawalList.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
                MonthlyTransactionCard(
                    displayMonthlyTransactions: displayMonthlyTransactions),
                WithdrawalListCard(
                  displayWithdrawalData: displayWithdrawalList,
                )
              ])
        : CalendarTimelineListCard(
            env: widget.env,
            timelineList: transactions,
            setReload: widget.setReload);
  }
}
