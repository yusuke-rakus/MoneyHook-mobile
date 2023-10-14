import 'package:money_hooks/src/api/categoryApi.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

import '../class/categoryClass.dart';
import '../env/envClass.dart';

class CategoryLoad {
  /// 【カテゴリ一覧取得】データ
  static void getCategoryList(Function setCategoryList) async {
    CategoryStorage.getCategoryListData().then((value) async {
      if (value.isEmpty) {
        CategoryApi.getCategoryList(setCategoryList);
      } else {
        setCategoryList(value);
      }
    });
  }

  /// 【サブカテゴリ一覧取得】データ
  static void getSubCategoryList(
      String userId, int categoryId, Function setSubCategoryList) async {
    CategoryStorage.getSubCategoryListData(categoryId.toString())
        .then((value) async {
      if (value.isEmpty) {
        CategoryApi.getSubCategoryList(userId, categoryId, setSubCategoryList);
      } else {
        setSubCategoryList(value);
      }
    });
  }

  /// 【サブカテゴリ一覧取得】データ
  static Future<void> getCategoryWithSubCategoryList(
      envClass env,
      Function setLoading,
      Function setSnackBar,
      Function setCategoryList) async {
    List<categoryClass> categoryList =
        await CategoryStorage.getCategoryWithSubCategoryListData();

    if (categoryList.isEmpty) {
      await CategoryApi.getCategoryWithSubCategoryList(
          env, setSnackBar, setCategoryList);
    } else {
      setCategoryList(categoryList);
    }
    setLoading();
  }
}
