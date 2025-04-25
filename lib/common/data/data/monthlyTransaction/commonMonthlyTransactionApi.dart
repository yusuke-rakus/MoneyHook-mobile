import 'package:dio/dio.dart';
import 'package:money_hooks/common/class/monthlyTransactionClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/data/data/monthlyTransaction/commonMonthlyTransactionStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';

class CommonMonthlyTransactionApi {
  static String rootURI = '${Api.rootURI}/fixed';

  /// 月次取引の取得
  static Future<void> getFixed(EnvClass env, Function setMonthlyTransactionList,
      Function setLoading, Function setSnackBar) async {
    Options? option = await Api.getHeader();
    try {
      Response res = await Api.dio.get('$rootURI/getFixed', options: option);
      if (res.statusCode != 200) {
        // 失敗
        setSnackBar(res.data['message']);
      } else {
        // 成功
        List<MonthlyTransactionClass> resultList = [];
        res.data['monthly_transaction_list'].forEach((value) {
          resultList.add(MonthlyTransactionClass.setFields(
            value['monthly_transaction_id'],
            value['monthly_transaction_name'],
            value['monthly_transaction_amount'],
            value['monthly_transaction_date'],
            value['category_id'],
            value['sub_category_id'],
            value['monthly_transaction_sign'],
            value['category_name'],
            value['sub_category_name'],
            value['payment_id'],
          ));
        });
        setMonthlyTransactionList(resultList);
        CommonMonthlyTransactionStorage.saveFixed(
            res.data['monthly_transaction_list'], env.getUserJson().toString());
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
    } finally {
      setLoading();
    }
  }
}
