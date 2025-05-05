import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/paymentGroup/class/groupByPaymentTransaction.dart';

class PaymentGroupTransactionStorage {
  static final db = Localstore.instance;

  /// 【支払い方法画面】データ
  static Future<GroupByPaymentTransaction> getGroupByPayment(
      String param) async {
    final id = 'group_payment_data$param';
    GroupByPaymentTransaction tran = GroupByPaymentTransaction();

    Map<String, dynamic>? value =
        await db.collection('group_by_payment').doc(id).get();
    if (value != null) {
      tran = GroupByPaymentTransaction.init(
          value['total_spending'],
          value['last_month_total_spending'],
          value['month_over_month_sum'],
          value['payment_list']);
    }

    return tran;
  }

  static void saveGroupByPaymentData(
      int totalSpending,
      int lastMonthTotalSpending,
      double? monthOverMonthSum,
      List<dynamic> paymentList,
      String param) async {
    await db
        .collection('group_by_payment')
        .doc('group_payment_data$param')
        .set({
      'total_spending': totalSpending,
      'last_month_total_spending': lastMonthTotalSpending,
      'month_over_month_sum': monthOverMonthSum,
      'payment_list': paymentList
    });
  }

  static void deleteGroupByPaymentData() async {
    await db.collection('group_by_payment').delete();
  }

  static void deleteGroupByPaymentDataWithParam(
      String userId, String transactionDate) async {
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'group_payment_data${env.getJson()}';
    await db.collection('group_by_payment').doc(id).delete();
  }
}
