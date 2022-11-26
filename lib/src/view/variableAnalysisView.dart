import "package:flutter/material.dart";

class VariableAnalysisView extends StatefulWidget {
  const VariableAnalysisView({super.key});

  @override
  State<VariableAnalysisView> createState() => _VariableAnalysis();
}

class _VariableAnalysis extends State<VariableAnalysisView> {
  final List<Map<String, dynamic>> monthlyVariableList = [
    {
      'categoryName': 'コンビニ',
      'categoryTotalAmount': '-10000',
      'subCategoryList': [
        {
          'subCategoryName': 'なし',
          'subCategoryTotalAmount': '10000',
          'transactionList': [
            {
              'transactionId': '1',
              'transactionName': 'タバコ',
              'transactionAmount': '450',
            },
            {
              'transactionId': '2',
              'transactionName': 'タバコ',
              'transactionAmount': '450',
            }
          ]
        },
        {
          'subCategoryName': '間食',
          'subCategoryTotalAmount': '10000',
          'transactionList': [
            {
              'transactionId': '3',
              'transactionName': 'チョコ',
              'transactionAmount': '450',
            },
            {
              'transactionId': '4',
              'transactionName': 'ポテチ',
              'transactionAmount': '450',
            }
          ]
        },
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // 月選択
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const Text('11月', style: TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          // 合計値
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            height: 60,
            child: Row(
              children: const [
                Text('変動費合計', style: TextStyle(fontSize: 17)),
                SizedBox(width: 20),
                Text('11,111', style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
          // 変動費
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            itemCount: monthlyVariableList.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                  title: Text('${monthlyVariableList[index]['categoryName']}'),
                  children: monthlyVariableList[index]['subCategoryList']
                      .map<Widget>((subCategory) => ExpansionTile(
                            title: Text(subCategory['subCategoryName']),
                            children: subCategory['transactionList']
                                .map<Widget>((tran) => ListTile(
                                    title: Text(tran['transactionName'])))
                                .toList(),
                          ))
                      .toList());
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ],
      ),
    );
  }
}
