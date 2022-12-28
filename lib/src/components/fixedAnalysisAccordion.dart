import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/transactionClass.dart';

class FixedAnalysisAccordion extends StatelessWidget {
  const FixedAnalysisAccordion({Key? key, required this.monthlyFixedList})
      : super(key: key);
  final List<dynamic> monthlyFixedList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: monthlyFixedList.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(monthlyFixedList[index]['categoryName']),
              Text(
                  '¥${transactionClass.formatNum(monthlyFixedList[index]['totalCategoryAmount'].abs())}'),
            ],
          ),
          children: monthlyFixedList[index]['transactionList']
              .map<Widget>((value) => ListTile(
                      title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value['transactionName']),
                      Text(
                          '¥${transactionClass.formatNum(value['transactionAmount'].abs())}'),
                    ],
                  )))
              .toList(),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
