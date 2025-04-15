import 'package:dio/dio.dart';
import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/class/subCategoryClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryStorage.dart';

class EditTranCategoryApi {
  static String rootURI = Api.rootURI;

  /// カテゴリ一覧の取得
  static Future<void> getCategoryList(Function setCategoryList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio
            .get('$rootURI/category/getCategoryList', options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<CategoryClass> categoryList = [];
          res.data['category_list'].forEach((value) {
            categoryList.add(
                CategoryClass(value['category_id'], value['category_name']));
          });
          setCategoryList(categoryList);
          EditTranCategoryStorage.saveCategoryList(categoryList);
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// サブカテゴリ一覧の取得
  static Future<void> getSubCategoryList(
      String userId, String categoryId, Function setSubCategoryList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get(
            '$rootURI/subCategory/getSubCategoryList/$categoryId',
            options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<SubCategoryClass> subCategoryList = [];
          res.data['sub_category_list'].forEach((value) {
            subCategoryList.add(SubCategoryClass(
                value['sub_category_id'], value['sub_category_name']));
          });
          EditTranCategoryStorage.saveSubCategoryList(
              subCategoryList, categoryId.toString());
          setSubCategoryList(subCategoryList);
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }
}
