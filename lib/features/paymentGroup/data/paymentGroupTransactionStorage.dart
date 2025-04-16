import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/env/envClass.dart';

class PaymentGroupTransactionStorage {
  static final db = Localstore.instance;

  /// 【支払い方法画面】データ
  static Future<Map<String, dynamic>> getGroupByPayment(String param) async {
    final id = 'group_payment_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('group_by_payment').doc(id).get().then((value) {
      if (value != null) {
        resultMap['total_spending'] = value['total_spending'];
        resultMap['last_month_total_spending'] =
            value['last_month_total_spending'];
        resultMap['month_over_month_sum'] = value['month_over_month_sum'];
        resultMap['payment_list'] = value['payment_list'];
      }
    });
    return resultMap;
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
