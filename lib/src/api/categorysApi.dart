import 'package:dio/dio.dart';
import 'package:money_hooks/src/class/categoryClass.dart';
import 'package:money_hooks/src/class/subCategoryClass.dart';

import 'api.dart';

class categorysApi {
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
      }
    });
  }

  static Future<void> getSubCategoryList(
      int categoryId, Function setSubCategoryList) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/subCategory/getSubCategoryList',
          data: {
            'userId': 'a77a6e94-6aa2-47ea-87dd-129f580fb669',
            'categoryId': categoryId
          });
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
