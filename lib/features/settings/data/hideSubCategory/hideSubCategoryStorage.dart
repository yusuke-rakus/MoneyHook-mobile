import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/class/subCategoryClass.dart';

class HideSubCategoryStorage {
  static final db = Localstore.instance;

  /// 【カテゴリ・サブカテゴリ一覧取得】データ
  static Future<List<CategoryClass>>
      getCategoryWithSubCategoryListData() async {
    List<CategoryClass> resultList = [];

    await db
        .collection('categoryWithSubCategoryData')
        .doc('categoryWithSubCategoryData')
        .get()
        .then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          List<SubCategoryClass> subCategoryList = [];
          e['subCategoryList'].forEach((subCategory) {
            subCategoryList.add(SubCategoryClass.setFullFields(
                subCategory['subCategoryId'],
                subCategory['subCategoryName'],
                subCategory['enable']));
          });

          resultList.add(CategoryClass.setCategoryWithSubCategory(
              e['categoryId'], e['categoryName'], subCategoryList));
        });
      }
    });
    return resultList;
  }

  static void saveCategoryWithSubCategoryList(
      List<CategoryClass> resultList) async {
    await db
        .collection('categoryWithSubCategoryData')
        .doc('categoryWithSubCategoryData')
        .set({
      'data': resultList.map((e) => e.getCategoryWithSubCategoryJson()).toList()
    });
  }

  static void deleteCategoryWithSubCategoryList() async {
    await db.collection('categoryWithSubCategoryData').delete();
  }
}
