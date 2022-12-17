import "package:flutter/material.dart";
import 'package:money_hooks/src/api/categorysApi.dart';
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/selectSubCategory.dart';

class SelectCategory extends StatefulWidget {
  SelectCategory(this.env, {super.key});

  envClass env;

  @override
  State<StatefulWidget> createState() => _SelectCategory();
}

class _SelectCategory extends State<SelectCategory> {
  late List<categoryClass> categoryList = [];
  late envClass env;

  void setCategoryList(List<categoryClass> responseList) {
    setState(() {
      categoryList = responseList;
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    categorysApi.getCategoryList(setCategoryList);
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
