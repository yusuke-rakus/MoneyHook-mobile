import "package:flutter/material.dart";
import 'package:money_hooks/src/dataLoader/categoryLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../class/subCategoryClass.dart';

class SelectSubCategory extends StatefulWidget {
  SelectSubCategory(this.env, this.categoryId, this.categoryName, {super.key});

  envClass env;
  int categoryId;
  String categoryName;

  @override
  State<StatefulWidget> createState() => _SelectSubCategory();
}

class _SelectSubCategory extends State<SelectSubCategory> {
  late List<subCategoryClass> subCategoryList = [];
  late String categoryName;
  late int categoryId;
  late envClass env;

  void setSubCategoryList(List<subCategoryClass> responseList) {
    setState(() {
      subCategoryList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    categoryName = widget.categoryName;
    categoryId = widget.categoryId;
    CategoryLoad.getSubCategoryList(env.userId, categoryId, setSubCategoryList);
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
