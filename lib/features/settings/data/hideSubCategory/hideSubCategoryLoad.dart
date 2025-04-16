import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/settings/data/hideSubCategory/hideSubCategoryApi.dart';
import 'package:money_hooks/features/settings/data/hideSubCategory/hideSubCategoryStorage.dart';

class HideSubCategoryLoad {
  /// 【サブカテゴリ一覧取得】データ
  static Future<void> getCategoryWithSubCategoryList(
      EnvClass env,
      Function setLoading,
      Function setSnackBar,
      Function setCategoryList) async {
    List<CategoryClass> categoryList =
        await HideSubCategoryStorage.getCategoryWithSubCategoryListData();

    if (categoryList.isEmpty) {
      await HideSubCategoryApi.getCategoryWithSubCategoryList(
          env, setSnackBar, setCategoryList);
    } else {
      setCategoryList(categoryList);
    }
    setLoading();
  }
}
