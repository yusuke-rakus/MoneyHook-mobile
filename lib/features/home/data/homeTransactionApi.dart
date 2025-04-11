import 'package:dio/dio.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/home/data/homeTransactionStorage.dart';

class HomeTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  static Future<void> getHome(EnvClass env, Function setLoading,
      Function setSnackBar, Function setHomeTransaction) async {
    setLoading();

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/getHome',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          setHomeTransaction(res.data['balance'], res.data['category_list']);
          HomeTransactionStorage.saveStorageHomeData(res.data['balance'],
              res.data['category_list'], env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }
}
