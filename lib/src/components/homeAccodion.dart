import 'package:flutter/material.dart';

class HomeAccodion extends StatelessWidget {
  const HomeAccodion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categoryList = [
      {
        'categoryName': '食費',
        'categoryTotalAmount': '-10000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー',
            'subCategoryTotalAmount': '10000',
          },
          {
            'subCategoryName': 'なし',
            'subCategoryTotalAmount': '10000',
          },
        ]
      },
      {
        'categoryName': '食費2',
        'categoryTotalAmount': '-20000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー2',
            'subCategoryTotalAmount': '20000',
          },
          {
            'subCategoryName': 'なし2',
            'subCategoryTotalAmount': '20000',
          },
        ]
      },
      {
        'categoryName': '食費2',
        'categoryTotalAmount': '-20000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー2',
            'subCategoryTotalAmount': '20000',
          },
          {
            'subCategoryName': 'なし2',
            'subCategoryTotalAmount': '20000',
          },
        ]
      },
      {
        'categoryName': '食費2',
        'categoryTotalAmount': '-20000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー2',
            'subCategoryTotalAmount': '20000',
          },
          {
            'subCategoryName': 'なし2',
            'subCategoryTotalAmount': '20000',
          },
        ]
      },
      {
        'categoryName': '食費2',
        'categoryTotalAmount': '-20000',
        'subCategoryList': [
          {
            'subCategoryName': 'スーパー2',
            'subCategoryTotalAmount': '20000',
          },
          {
            'subCategoryName': 'なし2',
            'subCategoryTotalAmount': '20000',
          },
        ]
      }
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: categoryList.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: Text('${categoryList[index]['categoryName']}'),
          children: categoryList[index]['subCategoryList']
              .map<Widget>(
                  (value) => ListTile(title: Text(value['subCategoryName'])))
              .toList(),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
