import 'package:money_hooks/src/api/categoryApi.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

import '../class/categoryClass.dart';
import '../env/envClass.dart';

class CategoryLoad {
  /// 【カテゴリ一覧取得】データ
  static Future<void> getCategoryList(Function setCategoryList) async {
    await CategoryStorage.getCategoryListData().then((value) async {
      if (value.isEmpty) {
        await CategoryApi.getCategoryList(setCategoryList);
      } else {
        setCategoryList(value);
      }
    });
  }

  /// 【サブカテゴリ一覧取得】データ
  static Future<void> getSubCategoryList(
      String userId, int categoryId, Function setSubCategoryList) async {
    await CategoryStorage.getSubCategoryListData(categoryId.toString())
        .then((value) async {
      if (value.isEmpty) {
        await CategoryApi.getSubCategoryList(
            userId, categoryId, setSubCategoryList);
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
    List<CategoryClass> categoryList =
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
