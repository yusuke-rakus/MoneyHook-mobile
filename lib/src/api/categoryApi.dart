import 'package:dio/dio.dart';
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/class/subCategoryClass.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

import '../env/envClass.dart';
import 'api.dart';

class CategoryApi {
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
          CategoryStorage.saveCategoryList(categoryList);
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// サブカテゴリ一覧の取得
  static Future<void> getSubCategoryList(
      String userId, int categoryId, Function setSubCategoryList) async {
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
          CategoryStorage.saveSubCategoryList(
              subCategoryList, categoryId.toString());
          setSubCategoryList(subCategoryList);
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// カテゴリ一覧の取得(サブカテゴリ含む)
  static Future<void> getCategoryWithSubCategoryList(
      envClass env, setSnackBar, Function setCategoryList) async {
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
          CategoryStorage.saveCategoryWithSubCategoryList(categoryList);
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// サブカテゴリの表示・非表示
  static Future<void> editSubCategory(
      envClass env, SubCategoryClass subCategory, int categoryId) async {
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
          CategoryStorage.deleteSubCategoryListWithParam(categoryId.toString());
          CategoryStorage.deleteCategoryWithSubCategoryList();
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }
}
