import 'package:flutter/material.dart';

class FixedAnalysisAccodion extends StatelessWidget {
  const FixedAnalysisAccodion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> monthlyFixedList = [
      {
        'categoryName': '給与',
        'totalCategoryAmount': '10000',
        'transactionList': [
          {
            'transactionName': '給与',
            'transactionAmount': '10000',
          },
        ]
      },{
        'categoryName': '配当',
        'totalCategoryAmount': '2000',
        'transactionList': [
          {
            'transactionName': 'S&P500',
            'transactionAmount': '2000',
          },
        ]
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: monthlyFixedList.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: Text('${monthlyFixedList[index]['categoryName']}'),
          children: monthlyFixedList[index]['transactionList']
              .map<Widget>(
                  (value) => ListTile(title: Text(value['transactionName'])))
              .toList(),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
