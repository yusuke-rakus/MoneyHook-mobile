import 'package:money_hooks/src/api/categoryApi.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

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
}
