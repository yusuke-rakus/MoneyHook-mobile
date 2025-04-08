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
  static Future<List<CategoryClass>> getCategoryListData() async {
    List<CategoryClass> resultList = [];

    await db.collection('categoryData').doc('categoryData').get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(CategoryClass(e['categoryId'], e['categoryName']));
        });
      }
    });
    return resultList;
  }

  static void saveCategoryList(List<CategoryClass> resultList) async {
    await db
        .collection('categoryData')
        .doc('categoryData')
        .set({'data': resultList.map((e) => e.getCategoryJson()).toList()});
  }

  static void deleteCategoryList() async {
    await db.collection('categoryData').delete();
  }

  /// 【サブカテゴリ一覧取得】データ
  static Future<List<SubCategoryClass>> getSubCategoryListData(
      String param) async {
    List<SubCategoryClass> resultList = [];
    final id = 'subCategoryData$param';

    await db.collection('subCategoryData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList
              .add(SubCategoryClass(e['subCategoryId'], e['subCategoryName']));
        });
      }
    });
    return resultList;
  }

  static void saveSubCategoryList(
      List<SubCategoryClass> resultList, String param) async {
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

  static Future<CategoryClass> getDefaultValue() async {
    CategoryClass category =
        CategoryClass.setDefaultValue('1', '食費', '1', 'なし');
    await db.collection('defaultValue').doc('defaultValue').get().then((value) {
      if (value != null) {
        category.categoryId = value['categoryId'].toString();
        category.categoryName = value['categoryName'];
        category.subCategoryId = value['subCategoryId'].toString();
        category.subCategoryName = value['subCategoryName'];
      }
    });
    return category;
  }

  static Future<void> saveDefaultValue(CategoryClass category) async {
    await db.collection('defaultValue').doc('defaultValue').set({
      'categoryId': category.categoryId,
      'categoryName': category.categoryName,
      'subCategoryId': category.subCategoryId,
      'subCategoryName': category.subCategoryName,
    });
  }

  static void deleteDefaultValue() async {
    await db.collection('defaultValue').delete();
  }
}
