import 'package:money_hooks/common/data/registrationDate.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionApi.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionStorage.dart';

class PaymentGroupTransactionLoad {
  /// 【支払い方法画面】データ
  static Future<void> getGroupByPayment(EnvClass env, Function setLoading,
      Function setSnackBar, Function setGroupByPaymentTransaction) async {
    Map<String, dynamic> value =
        await PaymentGroupTransactionStorage.getGroupByPayment(
            env.getJson().toString());

    if (value.isEmpty || await isNeedApi()) {
      await PaymentGroupTransactionApi.getGroupByPayment(
          env, setLoading, setSnackBar, setGroupByPaymentTransaction);
      await setRegistrationDate();
    } else {
      setGroupByPaymentTransaction(
          value['total_spending'],
          value['last_month_total_spending'],
          value['month_over_month_sum'],
          value['payment_list']);
    }
  }
}
