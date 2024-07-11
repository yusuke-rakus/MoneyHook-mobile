import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/monthlyTransactionClass.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/centerWidget.dart';

class MonthlyTransactionCard extends StatelessWidget {
  final List<MonthlyTransactionClass> displayMonthlyTransactions;

  const MonthlyTransactionCard(
      {super.key, required this.displayMonthlyTransactions});

  @override
  Widget build(BuildContext context) {
    return displayMonthlyTransactions.isNotEmpty
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
                      '自動入力予定',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    leading: Icon(Icons.account_tree),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    itemCount: displayMonthlyTransactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _monthlyTransactionItem(
                          displayMonthlyTransactions[index]);
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

  Widget _monthlyTransactionItem(
      MonthlyTransactionClass displayMonthlyTransaction) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '${displayMonthlyTransaction.monthlyTransactionDate}日',
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              displayMonthlyTransaction.categoryName,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              displayMonthlyTransaction.monthlyTransactionName,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '¥${TransactionClass.formatNum(displayMonthlyTransaction.monthlyTransactionAmount.toInt())}',
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
