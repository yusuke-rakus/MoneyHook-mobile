import 'package:dio/dio.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/home/class/homeTransaction.dart';
import 'package:money_hooks/features/home/data/homeTransactionStorage.dart';

class HomeTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  static Future<void> getHome(EnvClass env, Function setLoading,
      Function setSnackBar, Function setHomeTransaction) async {
    setLoading();

    Options? option = await Api.getHeader();
    try {
      Response res = await Api.dio.get('$rootURI/getHome',
          queryParameters: env.getJson(), options: option);
      if (res.statusCode != 200) {
        // 失敗
      } else {
        // 成功
        List<Category> categoryList = [];
        res.data['category_list'].forEach((category) {
          List<SubCategory> subCategoryList = [];
          category['sub_category_list'].forEach((subCategory) {
            subCategoryList.add(SubCategory(
                subCategoryName: subCategory['sub_category_name'],
                subCategoryTotalAmount:
                    subCategory['sub_category_total_amount']));
          });
          categoryList.add(Category(
              categoryName: category['category_name'],
              categoryTotalAmount: category['category_total_amount'],
              subCategoryList: subCategoryList));
        });

        setHomeTransaction(res.data['balance'], categoryList);
        HomeTransactionStorage.saveStorageHomeData(res.data['balance'],
            res.data['category_list'], env.getJson().toString());
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
    } finally {
      setLoading();
    }
  }
}
