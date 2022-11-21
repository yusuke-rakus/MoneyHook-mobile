import "package:flutter/material.dart";

import '../class/subCategoryClass.dart';

class SelectSubCategory extends StatefulWidget {
  SelectSubCategory(this.categoryId, this.categoryName, {super.key});

  int categoryId;
  String categoryName;

  List<subCategoryClass> subCategoryList = [
    subCategoryClass(1, 'サブカテゴリサブカテゴリサブカテゴリサブカテゴリサブカテゴリサブカテゴリサブカテゴリ'),
    subCategoryClass(2, 'サブスクリプション'),
    subCategoryClass(3, '食費'),
    subCategoryClass(4, '趣味'),
    subCategoryClass(5, '映画'),
    subCategoryClass(6, 'ラーメン'),
    subCategoryClass(7, '外食'),
    subCategoryClass(8, 'エンタメ'),
    subCategoryClass(9, 'スポーツ'),
    subCategoryClass(10, 'ショッピング'),
  ];

  @override
  State<StatefulWidget> createState() => _SelectSubCategory();
}

class _SelectSubCategory extends State<SelectSubCategory> {
  late List<subCategoryClass> subCategoryList;
  late String categoryName;
  late int categoryId;

  @override
  void initState() {
    super.initState();
    subCategoryList = widget.subCategoryList;
    categoryName = widget.categoryName;
    categoryId = widget.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カテゴリ'),
      ),
      body: ListView.builder(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          itemCount: subCategoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context, {
                  'categoryName': categoryName,
                  'categoryId': categoryId,
                  'subCategoryName': subCategoryList[index].subCategoryName,
                  'subCategoryId': subCategoryList[index].subCategoryId,
                });
              },
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subCategoryList[index].subCategoryName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
