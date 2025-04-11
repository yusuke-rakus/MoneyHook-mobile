import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryApi.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryStorage.dart';

class EditTranCategoryLoad {
  /// 【カテゴリ一覧取得】データ
  static Future<void> getCategoryList(Function setCategoryList) async {
    await EditTranCategoryStorage.getCategoryListData().then((value) async {
      if (value.isEmpty) {
        await EditTranCategoryApi.getCategoryList(setCategoryList);
      } else {
        setCategoryList(value);
      }
    });
  }

  /// 【サブカテゴリ一覧取得】データ
  static Future<void> getSubCategoryList(
      String userId, String categoryId, Function setSubCategoryList) async {
    await EditTranCategoryStorage.getSubCategoryListData(categoryId)
        .then((value) async {
      if (value.isEmpty) {
        await EditTranCategoryApi.getSubCategoryList(
            userId, categoryId, setSubCategoryList);
      } else {
        setSubCategoryList(value);
      }
    });
  }
}
