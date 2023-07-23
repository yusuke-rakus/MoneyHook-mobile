import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/categoryApi.dart';
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/class/subCategoryClass.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/dataLoader/categoryLoad.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

import '../../components/commonSnackBar.dart';
import '../../env/envClass.dart';

class HideSubCategory extends StatefulWidget {
  HideSubCategory({Key? key, required this.env}) : super(key: key);
  envClass env;

  @override
  State<HideSubCategory> createState() => _HideSubCategoryState();
}

class _HideSubCategoryState extends State<HideSubCategory> {
  late envClass env;
  late List<categoryClass> categoryList = [];
  late String defaultIndex;
  late bool _isLoading;
  late bool _editMode;

  void setCategoryList(List<categoryClass> resultList) {
    setState(() {
      categoryList = resultList;
    });
  }

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  /// ラジオボタンのステータス
  void changeEditMode() {
    setState(() {
      _editMode = !_editMode;
    });
  }

  /// サブカテゴリの表示・非表示を処理
  void _changeEnable(bool status, int categoryNo, int subCategoryNo) {
    if (defaultIndex == '$categoryNo,$subCategoryNo') {
      CommonSnackBar.build(context: context, text: 'デフォルトのため非表示にできません');
    } else {
      setState(() {
        subCategoryClass subCategory =
            categoryList[categoryNo].subCategoryList[subCategoryNo];
        subCategory.enable = status;
        CategoryApi.editSubCategory(
            env, subCategory, categoryList[categoryNo].categoryId);
      });
    }
  }

  /// サブカテゴリの表示・非表示を処理
  void setDefaultCategory(
      int categoryIndex, int subCategoryIndex, bool isInit) {
    categoryClass category = categoryList[categoryIndex];
    subCategoryClass subCategory =
        categoryList[categoryIndex].subCategoryList[subCategoryIndex];

    categoryClass defaultCategory = categoryClass.setDefaultValue(
        category.categoryId,
        category.categoryName,
        subCategory.subCategoryId,
        subCategory.subCategoryName);
    CategoryStorage.saveDefaultValue(defaultCategory).then((value) {
      if (!isInit) {
        CommonSnackBar.build(context: context, text: 'デフォルトを変更しました');
      }
    });
  }

  /// インデックス番号を取得
  void _changeDefaultIndex(String value, bool isInit) {
    int index = int.parse(value.split(',')[0]);
    int subCategoryKey = int.parse(value.split(',')[1]);

    if (categoryList[index].subCategoryList[subCategoryKey].enable) {
      setDefaultCategory(index, subCategoryKey, isInit);
      setState(() {
        defaultIndex = '$index,$subCategoryKey';
      });
    } else {
      CommonSnackBar.build(context: context, text: '非表示のためデフォルトにできません');
    }
  }

  /// デフォルトのカテゴリから、インデックス番号を取得
  void _setDefaultValue(categoryClass defaultCategory, bool isInit) {
    categoryList.asMap().forEach((i, category) {
      if (defaultCategory.categoryName == category.categoryName) {
        category.subCategoryList.asMap().forEach((t, subCategory) {
          if (defaultCategory.subCategoryName == subCategory.subCategoryName) {
            _changeDefaultIndex('$i, $t', isInit);
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = true;
    _editMode = false;
    CategoryLoad.getCategoryWithSubCategoryList(
            env, setLoading, setCategoryList)
        .then((value) {
      CategoryStorage.getDefaultValue()
          .then((value) => _setDefaultValue(value, true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('設定')),
        actions: [
          _editMode
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => changeEditMode(),
                )
              : IconButton(
                  icon: const Icon(Icons.create),
                  onPressed: () => changeEditMode(),
                )
        ],
      ),
      body: _isLoading
          ? Center(child: CommonLoadingAnimation.build())
          : Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 20),
                    height: 55,
                    child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'サブカテゴリの表示',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(categoryList[index].categoryName),
                            ],
                          ),
                          children: categoryList[index]
                              .subCategoryList
                              .asMap()
                              .entries
                              .map<Widget>((subCategory) => ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // デフォルト選択ボタン
                                        if (_editMode)
                                          Radio(
                                              value:
                                                  '$index,${subCategory.key}',
                                              groupValue: defaultIndex,
                                              onChanged: (e) {
                                                _changeDefaultIndex(e!, false);
                                              }),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        // サブカテゴリ名
                                        Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: subCategory
                                                  .value.subCategoryName),
                                          WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.top,
                                              child: Visibility(
                                                  visible:
                                                      '$index,${subCategory.key}' ==
                                                          defaultIndex,
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.blue,
                                                    size: 10,
                                                  ))),
                                        ])),
                                        const Spacer(),
                                      ],
                                    ),
                                    // スイッチボタン
                                    trailing: CupertinoSwitch(
                                        activeColor: Colors.blue,
                                        value: subCategory.value.enable,
                                        onChanged: (activeState) {
                                          _changeEnable(activeState, index,
                                              subCategory.key);
                                        }),
                                  ))
                              .toList(),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
