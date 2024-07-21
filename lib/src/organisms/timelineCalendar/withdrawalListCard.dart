import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/class/response/withdrawalData.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/centerWidget.dart';

class WithdrawalListCard extends StatelessWidget {
  final List<WithdrawalData> displayWithdrawalData;

  const WithdrawalListCard({super.key, required this.displayWithdrawalData});

  @override
  Widget build(BuildContext context) {
    return displayWithdrawalData.isNotEmpty
        ? CenterWidget(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5)),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const ListTile(
                    title: Text(
                      '引落し予定',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    leading: Icon(Icons.credit_card_outlined),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(children: [
                        _expandedText(flex: 1, text: '引落日'),
                        _expandedText(flex: 1, text: '支払方法'),
                        _expandedText(flex: 2, text: '集計期間'),
                        _expandedText(flex: 1, text: '金額'),
                      ])),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: displayWithdrawalData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _withdrawalItem(displayWithdrawalData[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _withdrawalItem(WithdrawalData withdrawalData) {
    return SizedBox(
        height: 35,
        child: Row(children: [
          _expandedText(flex: 1, text: '${withdrawalData.paymentDate}日'),
          _expandedText(flex: 1, text: withdrawalData.paymentName),
          _expandedText(
              flex: 2,
              text:
                  '${DateFormat('M月d日').format(withdrawalData.aggregationStartDate!)} - ${DateFormat('M月d日').format(withdrawalData.aggregationEndDate!)}'),
          _expandedText(
              flex: 1,
              text:
                  '¥${TransactionClass.formatNum(withdrawalData.withdrawalAmount.abs())}')
        ]));
  }

  Widget _expandedText({required int flex, required String text}) {
    return Expanded(
        flex: flex,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }
}
