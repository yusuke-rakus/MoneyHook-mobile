import 'package:localstore/localstore.dart';
import 'package:money_hooks/src/class/response/paymentResource.dart';

class PaymentResourceStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deletePaymentResourceList();
  }

  /// 【支払い方法画面】データ
  static Future<List<PaymentResourceData>> getPaymentResourceList(
      String param) async {
    final id = 'payment_resource_list$param';

    List<PaymentResourceData> resultList = [];

    await db.collection('payment_resource_list').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(PaymentResourceData.init(
            e['payment_id'],
            e['payment_name'],
            e['payment_type_id'],
            e['payment_date'],
            e['closing_date'],
          ));
        });
      }
    });
    return resultList;
  }

  static void savePaymentResourceList(
      List<PaymentResourceData> resultList, String param) async {
    await db
        .collection('payment_resource_list')
        .doc('payment_resource_list$param')
        .set({'data': resultList.map((e) => e.getPaymentJson()).toList()});
  }

  static Future<void> deletePaymentResourceList() async {
    await db.collection('payment_resource_list').delete();
  }
}
