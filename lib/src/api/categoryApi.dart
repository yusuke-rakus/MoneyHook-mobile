import 'package:dio/dio.dart';
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/class/subCategoryClass.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';

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
      }
    });
  }
}
