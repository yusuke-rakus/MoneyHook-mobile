import 'package:dio/dio.dart';
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/class/subCategoryClass.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

import '../env/envClass.dart';
import 'api.dart';

class CategoryApi {
  static String rootURI = Api.rootURI;
  static Dio dio = Dio();

  static Future<void> getCategoryList(Function setCategoryList) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/category/getCategoryList');
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<categoryClass> categoryList = [];
        res.data['categoryList'].forEach((value) {
          categoryList
              .add(categoryClass(value['categoryId'], value['categoryName']));
        });
        setCategoryList(categoryList);
        CategoryStorage.saveCategoryList(categoryList);
      }
    });
  }

  static Future<void> getSubCategoryList(
      String userId, int categoryId, Function setSubCategoryList) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/subCategory/getSubCategoryList',
          data: {'userId': userId, 'categoryId': categoryId});
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<subCategoryClass> subCategoryList = [];
        res.data['subCategoryList'].forEach((value) {
          subCategoryList.add(subCategoryClass(
              value['subCategoryId'], value['subCategoryName']));
        });
        setSubCategoryList(subCategoryList);
        CategoryStorage.saveSubCategoryList(
            subCategoryList, categoryId.toString());
      }
    });
  }

  static Future<void> getCategoryWithSubCategoryList(
      envClass env, Function setLoading, Function setCategoryList) async {
    await Future(() async {
      Response res = await dio.post(
          '$rootURI/category/getCategoryWithSubCategoryList',
          data: env.getUserJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<categoryClass> categoryList = [];
        res.data['categoryList'].forEach((value) {
          List<subCategoryClass> subCategoryList = [];
          value['subCategoryList'].forEach((subCategory) {
            subCategoryList.add(subCategoryClass.setFullFields(
                subCategory['subCategoryId'],
                subCategory['subCategoryName'],
                subCategory['enable']));
          });

          categoryList.add(categoryClass.setCategoryWithSubCategory(
              value['categoryId'], value['categoryName'], subCategoryList));
        });
        setCategoryList(categoryList);
        CategoryStorage.saveCategoryWithSubCategoryList(categoryList);
      }
      setLoading();
    });
  }

  /// サブカテゴリの表示・非表示
  static Future<void> editSubCategory(
      envClass env, subCategoryClass subCategory, int categoryId) async {
    await Future(() async {
      Response res =
          await dio.post('$rootURI/subCategory/editSubCategory', data: {
        'userId': env.userId,
        'subCategoryId': subCategory.subCategoryId,
        'enable': subCategory.enable
      });
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        CategoryStorage.deleteSubCategoryListWithParam(categoryId.toString());
        CategoryStorage.deleteCategoryWithSubCategoryList();
      }
    });
  }
}
