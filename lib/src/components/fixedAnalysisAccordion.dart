import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/centerWidget.dart';

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
        return CenterWidget(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(monthlyFixedList[index]['category_name']),
                  Text(
                      '¥${TransactionClass.formatNum(monthlyFixedList[index]['total_category_amount'].abs())}'),
                ],
              ),
              textColor: Colors.black,
              children: monthlyFixedList[index]['transaction_list']
                  .map<Widget>((value) => ListTile(
                          title: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                  '${DateFormat('yyyy-MM-dd').parse(value['transaction_date']).day}日')),
                          Expanded(
                              flex: 5, child: Text(value['transaction_name'])),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                const Expanded(child: SizedBox()),
                                Text(
                                    '¥${TransactionClass.formatNum(value['transaction_amount'].abs())}'),
                              ],
                            ),
                          ),
                        ],
                      )))
                  .toList(),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return CenterWidget(child: const Divider());
      },
    );
  }
}
