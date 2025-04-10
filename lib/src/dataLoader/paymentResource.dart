import '../api/paymentResourceApi.dart';
import '../common/env/envClass.dart';
import '../searchStorage/paymentResourceStorage.dart';

class PaymentResourceLoad {
  /// 【支払い方法画面】データ
  static Future<void> getPaymentResource(
      EnvClass env, Function setPaymentResourceList) async {
    await PaymentResourceStorage.getPaymentResourceList(
            env.getUserJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        await PaymentResourceApi.getPaymentResourceList(
            env, setPaymentResourceList);
      } else {
        setPaymentResourceList(value);
      }
    });
  }
}
