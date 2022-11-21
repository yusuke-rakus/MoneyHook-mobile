import "package:flutter/material.dart";
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/modals/selectSubCategory.dart';

class SelectCategory extends StatefulWidget {
  SelectCategory({super.key});

  List<categoryClass> categoryList = [
    categoryClass(1, 'サブスクリプションサブスクリプションサブスクリプションサブスクリプション'),
    categoryClass(2, 'サブスクリプション'),
    categoryClass(3, '食費'),
    categoryClass(4, '趣味'),
    categoryClass(5, '映画'),
    categoryClass(6, 'ラーメン'),
    categoryClass(7, '外食'),
    categoryClass(8, 'エンタメ'),
    categoryClass(9, 'スポーツ'),
    categoryClass(10, 'ショッピング'),
  ];

  @override
  State<StatefulWidget> createState() => _SelectCategory();
}

class _SelectCategory extends State<SelectCategory> {
  late List<categoryClass> categoryList;

  @override
  void initState() {
    super.initState();
    categoryList = widget.categoryList;
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
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSubCategory(
                        categoryList[index].categoryId,
                        categoryList[index].categoryName),
                  ),
                );
              },
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        categoryList[index].categoryName,
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
