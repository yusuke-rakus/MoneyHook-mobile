import 'package:localstore/localstore.dart';

class PaymentResourceStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deletePaymentResourceList();
  }

  /// 【支払い方法画面】データ
  static Future<dynamic> getPaymentResourceList(String param) async {
    final id = 'payment_resource_list$param';
    dynamic result = await db.collection('payment_resource_list').doc(id).get();
    if (result == null) {
      return [];
    }
    return result["data"];
  }

  static void savePaymentResourceList(
      List<dynamic> resultList, String param) async {
    await db
        .collection('payment_resource_list')
        .doc('payment_resource_list$param')
        .set({'data': resultList});
  }

  static Future<void> deletePaymentResourceList() async {
    await db.collection('payment_resource_list').delete();
  }
}
