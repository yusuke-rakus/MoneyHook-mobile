import "package:flutter/material.dart";
import 'package:money_hooks/src/api/categorysApi.dart';

import '../class/subCategoryClass.dart';

class SelectSubCategory extends StatefulWidget {
  SelectSubCategory(this.categoryId, this.categoryName, {super.key});

  int categoryId;
  String categoryName;

  @override
  State<StatefulWidget> createState() => _SelectSubCategory();
}

class _SelectSubCategory extends State<SelectSubCategory> {
  late List<subCategoryClass> subCategoryList = [];
  late String categoryName;
  late int categoryId;

  void setSubCategoryList(List<subCategoryClass> responseList) {
    setState(() {
      subCategoryList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    categoryName = widget.categoryName;
    categoryId = widget.categoryId;
    categorysApi.getSubCategoryList(categoryId, setSubCategoryList);
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
              child: SizedBox(
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
