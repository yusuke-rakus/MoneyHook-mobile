import 'package:localstore/localstore.dart';

import '../class/categoryClass.dart';

class CategoryStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteCategoryList();
  }

  /// 【カテゴリ一覧取得】データ
  static Future<List<categoryClass>> getCategoryListData(
      Function setCategoryList) async {
    List<categoryClass> resultList = [];
    const id = 'categoryData';

    await db.collection('categoryData').doc(id).get().then((value) {
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

  /// 【カテゴリ一覧取得】データ
  static Future<List<categoryClass>> getSubCategoryListData(
      Function setCategoryList) async {
    List<categoryClass> resultList = [];
    const id = 'categoryData';

    await db.collection('categoryData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(categoryClass(e['categoryId'], e['categoryName']));
        });
      }
    });
    return resultList;
  }

  static void saveSubCategoryList(
      List<categoryClass> resultList, String param) async {
    await db
        .collection('subCategoryData')
        .doc('categoryData$param')
        .set({'data': resultList.map((e) => e.getCategoryJson()).toList()});
  }

  static void deleteSubCategoryList() async {
    await db.collection('subCcategoryData').delete();
  }
}
