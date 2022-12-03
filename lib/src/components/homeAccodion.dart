import 'package:flutter/material.dart';

class HomeAccordion extends StatelessWidget {
  const HomeAccordion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categoryList = [
      {
        'categoryName': '食費',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '-10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '-10000',
          },
        ]
      },
      {
        'categoryName': '食費',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '-10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '-10000',
          },
        ]
      },
      {
        'categoryName': '食費',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '-10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '-10000',
          },
        ]
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: categoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${categoryList[index]['categoryName']}'),
              Text('${categoryList[index]['categoryTotalAmount']}'),
            ],
          ),
          children: categoryList[index]['subCategoryList']
              .map<Widget>((value) => ListTile(
                      title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value['subCategoryName']),
                      Text(value['subCategoryTotalAmount']),
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
