import 'package:dio/dio.dart';
import 'package:money_hooks/src/env/env.dart';

import 'api.dart';

class transactionApi {
  static String rootURI = '${Api.rootURI}/user';
  static Dio dio = Dio();

  static Future<void> getHome(envClass env, Function setLoading) async {
    setLoading();
    await Future(() async {
      Response res = await dio.post('$rootURI/getHome');
      if (res.data['status'] == 'error') {
      } else {}
    });

    // print(env.thisMonth);
    // homeTransactinList.categoryList = [
    //   {
    //     'categoryName': '変わったよ',
    //     'categoryTotalAmount': '-10000',
    //     'subCategoryList': [
    //       {
    //         'subCategoryName': 'スーパー',
    //         'subCategoryTotalAmount': '-10000',
    //       },
    //       {
    //         'subCategoryName': 'なし',
    //         'subCategoryTotalAmount': '-10000',
    //       },
    //     ]
    //   },
    // ];
  }
}
