import 'package:dio/dio.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionStorage.dart';

class PaymentGroupTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  /// 支払い方法毎の支出を取得
  static Future<void> getGroupByPayment(EnvClass env, Function setLoading,
      Function setSnackBar, Function setPaymentGroupTransaction) async {
    setLoading();

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/groupByPayment',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          setPaymentGroupTransaction(
              res.data['total_spending'],
              res.data['last_month_total_spending'],
              res.data['month_over_month_sum'],
              res.data['payment_list']);
          PaymentGroupTransactionStorage.saveGroupByPaymentData(
              res.data['total_spending'],
              res.data['last_month_total_spending'],
              res.data['month_over_month_sum'],
              res.data['payment_list'],
              env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }
}
