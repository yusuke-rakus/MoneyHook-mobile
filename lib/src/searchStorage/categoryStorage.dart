import 'package:localstore/localstore.dart';

import '../class/categoryClass.dart';
import '../class/subCategoryClass.dart';

class CategoryStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteCategoryList();
    deleteSubCategoryList();
    deleteCategoryWithSubCategoryList();
  }

  /// 【カテゴリ一覧取得】データ
  static Future<List<categoryClass>> getCategoryListData() async {
    List<categoryClass> resultList = [];

    await db.collection('categoryData').doc('categoryData').get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(categoryClass(e['categoryId'], e['categoryName']));
        });
      }
    });
    return resultList;
  }

  static void saveCategoryList(List<categoryClass> resultList) async {
    await db
        .collection('categoryData')
        .doc('categoryData')
        .set({'data': resultList.map((e) => e.getCategoryJson()).toList()});
  }

  static void deleteCategoryList() async {
    await db.collection('categoryData').delete();
  }

  /// 【サブカテゴリ一覧取得】データ
  static Future<List<subCategoryClass>> getSubCategoryListData(
      String param) async {
    List<subCategoryClass> resultList = [];
    final id = 'subCategoryData$param';

    await db.collection('subCategoryData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList
              .add(subCategoryClass(e['subCategoryId'], e['subCategoryName']));
        });
      }
    });
    return resultList;
  }

  static void saveSubCategoryList(
      List<subCategoryClass> resultList, String param) async {
    await db
        .collection('subCategoryData')
        .doc('subCategoryData$param')
        .set({'data': resultList.map((e) => e.getSubCategoryJson()).toList()});
  }

  static void deleteSubCategoryList() async {
    await db.collection('subCategoryData').delete();
  }

  static void deleteSubCategoryListWithParam(String param) async {
    final id = 'subCategoryData$param';
    await db.collection('subCategoryData').doc(id).delete();
  }

  /// 【カテゴリ・サブカテゴリ一覧取得】データ
  static Future<List<categoryClass>>
      getCategoryWithSubCategoryListData() async {
    List<categoryClass> resultList = [];

    await db
        .collection('categoryWithSubCategoryData')
        .doc('categoryWithSubCategoryData')
        .get()
        .then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          List<subCategoryClass> subCategoryList = [];
          e['subCategoryList'].forEach((subCategory) {
            subCategoryList.add(subCategoryClass.setFullFields(
                subCategory['subCategoryId'],
                subCategory['subCategoryName'],
                subCategory['enable']));
          });

          resultList.add(categoryClass.setCategoryWithSubCategory(
              e['categoryId'], e['categoryName'], subCategoryList));
        });
      }
    });
    return resultList;
  }

  static void saveCategoryWithSubCategoryList(
      List<categoryClass> resultList) async {
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

  static Future<categoryClass> getDefaultValue() async {
    categoryClass category = categoryClass.setDefaultValue(1, '食費', 1, 'なし');
    await db.collection('defaultValue').doc('defaultValue').get().then((value) {
      if (value != null) {
        category.categoryId = value['categoryId'];
        category.categoryName = value['categoryName'];
        category.subCategoryId = value['subCategoryId'];
        category.subCategoryName = value['subCategoryName'];
      }
    });
    return category;
  }

  static Future<void> saveDefaultValue(categoryClass category) async {
    await db.collection('defaultValue').doc('defaultValue').set({
      'categoryId': category.categoryId,
      'categoryName': category.categoryName,
      'subCategoryId': category.subCategoryId,
      'subCategoryName': category.subCategoryName,
    });
  }
}
