import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/class/subCategoryClass.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryApi.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryStorage.dart';

class EditTranCategoryLoad {
  /// 【カテゴリ一覧取得】データ
  static Future<void> getCategoryList(Function setCategoryList) async {
    List<CategoryClass> value =
        await EditTranCategoryStorage.getCategoryListData();

    if (value.isEmpty) {
      await EditTranCategoryApi.getCategoryList(setCategoryList);
    } else {
      setCategoryList(value);
    }
  }

  /// 【サブカテゴリ一覧取得】データ
  static Future<void> getSubCategoryList(
      String userId, String categoryId, Function setSubCategoryList) async {
    List<SubCategoryClass> value =
        await EditTranCategoryStorage.getSubCategoryListData(categoryId);

    if (value.isEmpty) {
      await EditTranCategoryApi.getSubCategoryList(
          userId, categoryId, setSubCategoryList);
    } else {
      setSubCategoryList(value);
    }
  }
}
