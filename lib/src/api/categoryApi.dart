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
            .post('$rootURI/category/getCategoryList', options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<CategoryClass> categoryList = [];
          res.data['categoryList'].forEach((value) {
            categoryList
                .add(CategoryClass(value['categoryId'], value['categoryName']));
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
        Response res = await Api.dio.post(
            '$rootURI/subCategory/getSubCategoryList',
            data: {'userId': userId, 'categoryId': categoryId},
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<SubCategoryClass> subCategoryList = [];
          res.data['subCategoryList'].forEach((value) {
            subCategoryList.add(SubCategoryClass(
                value['subCategoryId'], value['subCategoryName']));
          });
          setSubCategoryList(subCategoryList);
          CategoryStorage.saveSubCategoryList(
              subCategoryList, categoryId.toString());
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
        Response res = await Api.dio.post(
            '$rootURI/category/getCategoryWithSubCategoryList',
            data: env.getUserJson(),
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<CategoryClass> categoryList = [];
          res.data['categoryList'].forEach((value) {
            List<SubCategoryClass> subCategoryList = [];
            value['subCategoryList'].forEach((subCategory) {
              subCategoryList.add(SubCategoryClass.setFullFields(
                  subCategory['subCategoryId'],
                  subCategory['subCategoryName'],
                  subCategory['enable']));
            });

            categoryList.add(CategoryClass.setCategoryWithSubCategory(
                value['categoryId'], value['categoryName'], subCategoryList));
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
        Response res =
            await Api.dio.post('$rootURI/subCategory/editSubCategory',
                data: {
                  'userId': env.userId,
                  'subCategoryId': subCategory.subCategoryId,
                  'enable': subCategory.enable
                },
                options: option);
        if (res.data['status'] == 'error') {
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
