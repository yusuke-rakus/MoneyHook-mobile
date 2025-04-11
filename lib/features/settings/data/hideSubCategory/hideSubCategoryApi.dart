import 'package:dio/dio.dart';
import 'package:money_hooks/class/categoryClass.dart';
import 'package:money_hooks/class/subCategoryClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryStorage.dart';
import 'package:money_hooks/features/settings/data/hideSubCategory/hideSubCategoryStorage.dart';

class HideSubCategoryApi {
  static String rootURI = Api.rootURI;

  /// サブカテゴリの表示・非表示
  static Future<void> editSubCategory(
      EnvClass env, SubCategoryClass subCategory, int categoryId) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post(
            '$rootURI/subCategory/editSubCategory',
            data: {
              'sub_category_id': subCategory.subCategoryId,
              'is_enable': subCategory.enable
            },
            options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          EditTranCategoryStorage.deleteSubCategoryListWithParam(
              categoryId.toString());
          HideSubCategoryStorage.deleteCategoryWithSubCategoryList();
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// カテゴリ一覧の取得(サブカテゴリ含む)
  static Future<void> getCategoryWithSubCategoryList(
      EnvClass env, setSnackBar, Function setCategoryList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get(
            '$rootURI/category/getCategoryWithSubCategoryList',
            queryParameters: env.getJson(),
            options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<CategoryClass> categoryList = [];
          res.data['category_list'].forEach((value) {
            List<SubCategoryClass> subCategoryList = [];
            value['sub_category_list'].forEach((subCategory) {
              subCategoryList.add(SubCategoryClass.setFullFields(
                  subCategory['sub_category_id'],
                  subCategory['sub_category_name'],
                  subCategory['enable']));
            });

            categoryList.add(CategoryClass.setCategoryWithSubCategory(
                value['category_id'], value['category_name'], subCategoryList));
          });
          setCategoryList(categoryList);
          HideSubCategoryStorage.saveCategoryWithSubCategoryList(categoryList);
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
