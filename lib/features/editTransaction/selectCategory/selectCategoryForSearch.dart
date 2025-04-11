import "package:flutter/material.dart";
import 'package:money_hooks/class/categoryClass.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryLoad.dart';
import 'package:money_hooks/features/editTransaction/selectSubCategory/selectSubCategoryForSearch.dart';

class SelectCategoryForSearch extends StatefulWidget {
  const SelectCategoryForSearch(this.env, {super.key});

  final EnvClass env;

  @override
  State<StatefulWidget> createState() => _SelectCategoryForSearch();
}

class _SelectCategoryForSearch extends State<SelectCategoryForSearch> {
  late List<CategoryClass> categoryList = [];
  late EnvClass env;

  void setCategoryList(List<CategoryClass> responseList) {
    setState(() {
      categoryList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    EditTranCategoryLoad.getCategoryList(setCategoryList);
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
                      builder: (context) => SelectSubCategoryForSearch(
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
                          style: TextStyle(
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
              ),
            );
          }),
    );
  }
}
