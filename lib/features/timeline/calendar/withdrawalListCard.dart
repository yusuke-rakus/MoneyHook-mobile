import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/features/timeline/class/withdrawalData.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/widgets/cardWidget.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';

class WithdrawalListCard extends StatelessWidget {
  final List<WithdrawalData> displayWithdrawalData;

  const WithdrawalListCard({super.key, required this.displayWithdrawalData});

  @override
  Widget build(BuildContext context) {
    return displayWithdrawalData.isNotEmpty
        ? CenterWidget(
            child: CardWidget(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListTile(
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
                        _expandedText(context: context, flex: 1, text: '引落日'),
                        _expandedText(context: context, flex: 1, text: '支払方法'),
                        _expandedText(context: context, flex: 2, text: '集計期間'),
                        _expandedText(context: context, flex: 1, text: '金額'),
                      ])),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: displayWithdrawalData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _withdrawalItem(
                          context, displayWithdrawalData[index]);
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

  Widget _withdrawalItem(BuildContext context, WithdrawalData withdrawalData) {
    return SizedBox(
        height: 35,
        child: Row(children: [
          _expandedText(
              context: context,
              flex: 1,
              text: '${withdrawalData.paymentDate}日'),
          _expandedText(
              context: context, flex: 1, text: withdrawalData.paymentName),
          _expandedText(
              context: context,
              flex: 2,
              text:
                  '${DateFormat('M月d日').format(withdrawalData.aggregationStartDate!)} - ${DateFormat('M月d日').format(withdrawalData.aggregationEndDate!)}'),
          _expandedText(
              context: context,
              flex: 1,
              text:
                  '¥${TransactionClass.formatNum(withdrawalData.withdrawalAmount.abs())}')
        ]));
  }

  Widget _expandedText(
      {required BuildContext context,
      required int flex,
      required String text}) {
    return Expanded(
        flex: flex,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }
}
