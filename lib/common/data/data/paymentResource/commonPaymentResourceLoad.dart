import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceApi.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';

class CommonPaymentResourceLoad {
  /// 【支払い方法画面】データ
  static Future<void> getPaymentResource(
      EnvClass env, Function setPaymentResourceList) async {
    List<PaymentResourceData> value =
        await CommonPaymentResourceStorage.getPaymentResourceList(
            env.getUserJson().toString());

    if (value.isEmpty) {
      await CommonPaymentResourceApi.getPaymentResourceList(
          env, setPaymentResourceList);
    } else {
      setPaymentResourceList(value);
    }
  }
}
