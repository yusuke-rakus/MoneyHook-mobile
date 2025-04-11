import 'package:localstore/localstore.dart';
import 'package:money_hooks/class/monthlyTransactionClass.dart';

class CommonMonthlyTransactionStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteFixed();
  }

  /// 【収支の自動入力画面】データ
  static Future<List<MonthlyTransactionClass>> getFixed(String param) async {
    final id = 'monthly_transaction_data$param';
    List<MonthlyTransactionClass> resultList = [];

    await db.collection('monthly_transaction_data').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(MonthlyTransactionClass.setFields(
              e['monthly_transaction_id'],
              e['monthly_transaction_name'],
              e['monthly_transaction_amount'],
              e['monthly_transaction_date'],
              e['category_id'],
              e['sub_category_id'],
              e['monthly_transaction_sign'],
              e['category_name'],
              e['sub_category_name'],
              e['payment_id']));
        });
      }
    });
    return resultList;
  }

  static void saveFixed(List<dynamic> resultList, String param) async {
    await db
        .collection('monthly_transaction_data')
        .doc('monthly_transaction_data$param')
        .set({'data': resultList});
  }

  static void deleteFixed() async {
    await db.collection('monthly_transaction_data').delete();
  }
}
