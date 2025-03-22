import "package:flutter/material.dart";
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/dataLoader/categoryLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/selectSubCategory.dart';

import '../components/centerWidget.dart';
import '../components/gradientBar.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory(this.env, {super.key});

  final envClass env;

  @override
  State<StatefulWidget> createState() => _SelectCategory();
}

class _SelectCategory extends State<SelectCategory> {
  late List<CategoryClass> categoryList = [];
  late envClass env;

  void setCategoryList(List<CategoryClass> responseList) {
    setState(() {
      categoryList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    CategoryLoad.getCategoryList(setCategoryList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientBar(),
        title: const Text('カテゴリ'),
      ),
      body: ListView.builder(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return CenterWidget(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectSubCategory(
                          env,
                          categoryList[index].categoryId,
                          categoryList[index].categoryName),
                    ),
                  );
                },
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          categoryList[index].categoryName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 20.0),
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
              ),
            );
          }),
    );
  }
}
