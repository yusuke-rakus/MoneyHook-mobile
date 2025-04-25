import 'package:money_hooks/common/data/registrationDate.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/paymentGroup/class/groupByPaymentTransaction.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionApi.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionStorage.dart';

class PaymentGroupTransactionLoad {
  /// 【支払い方法画面】データ
  static Future<GroupByPaymentTransaction> getGroupByPayment(
      EnvClass env, Function setLoading, Function setSnackBar) async {
    GroupByPaymentTransaction transaction = GroupByPaymentTransaction();

    GroupByPaymentTransaction value =
        await PaymentGroupTransactionStorage.getGroupByPayment(
            env.getJson().toString());

    if (value.paymentList.isEmpty || await isNeedApi()) {
      transaction = await PaymentGroupTransactionApi.getGroupByPayment(
          env, setLoading, setSnackBar);
      await setRegistrationDate();
    } else {
      transaction = value;
    }
    return transaction;
  }
}
