import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/class/subCategoryClass.dart';

class EditTranCategoryStorage {
  static final db = Localstore.instance;

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
}
