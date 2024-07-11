import 'package:flutter/material.dart';
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
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '${withdrawalData.paymentDate}日',
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              withdrawalData.paymentName,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '¥${TransactionClass.formatNum(withdrawalData.withdrawalAmount.abs())}',
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
