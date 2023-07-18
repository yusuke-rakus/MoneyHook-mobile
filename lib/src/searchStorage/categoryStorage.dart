import 'package:localstore/localstore.dart';

import '../class/categoryClass.dart';
import '../class/subCategoryClass.dart';

class CategoryStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteCategoryList();
    deleteSubCategoryList();
  }

  /// 【カテゴリ一覧取得】データ
  static Future<List<categoryClass>> getCategoryListData() async {
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
}
