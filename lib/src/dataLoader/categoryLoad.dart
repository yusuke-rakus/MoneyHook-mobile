import 'package:money_hooks/src/api/categoryApi.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

class CategoryLoad {
  /// 【貯金目標一覧取得】データ
  static void getCategoryList(Function setCategoryList) async {
    CategoryStorage.getCategoryListData(setCategoryList).then((value) async {
      if (value.isEmpty) {
        CategoryApi.getCategoryList(setCategoryList);
      } else {
        setCategoryList(value);
      }
    });
  }
}
