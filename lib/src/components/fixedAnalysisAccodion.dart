import 'package:flutter/material.dart';

class FixedAnalysisAccordion extends StatelessWidget {
  const FixedAnalysisAccordion({Key? key}) : super(key: key);

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
      },
      {
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${monthlyFixedList[index]['categoryName']}'),
              Text('${monthlyFixedList[index]['totalCategoryAmount']}'),
            ],
          ),
          children: monthlyFixedList[index]['transactionList']
              .map<Widget>((value) => ListTile(
                      title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value['transactionName']),
                      Text(value['transactionAmount']),
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
