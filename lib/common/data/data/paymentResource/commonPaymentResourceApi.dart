import 'package:dio/dio.dart';
import 'package:money_hooks/class/response/paymentResource.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';

class CommonPaymentResourceApi {
  static String rootURI = Api.rootURI;

  /// 支払い方法一覧の取得
  static Future<void> getPaymentResourceList(
      EnvClass env, Function setPaymentResourceList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res =
            await Api.dio.get('$rootURI/payment/getPayment', options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<PaymentResourceData> resultList = [];
          res.data['payment_list'].forEach((value) {
            resultList.add(PaymentResourceData.init(
              value['payment_id'],
              value['payment_name'],
              value['payment_type_id'],
              value['payment_date'],
              value['closing_date'],
            ));
          });
          setPaymentResourceList(resultList);

          if (resultList.isNotEmpty) {
            CommonPaymentResourceStorage.savePaymentResourceList(
                resultList, env.getUserJson().toString());
          }
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }
}
