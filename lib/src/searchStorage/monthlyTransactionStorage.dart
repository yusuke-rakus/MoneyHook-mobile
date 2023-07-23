import 'package:localstore/localstore.dart';

import '../class/monthlyTransactionClass.dart';

class MonthlyTransactionStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteFixed();
  }

  /// 【収支の自動入力画面】データ
  static Future<List<monthlyTransactionClass>> getFixed(String param) async {
    final id = 'monthlyTransactionData$param';
    List<monthlyTransactionClass> resultList = [];

    await db.collection('monthlyTransactionData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(monthlyTransactionClass.setFields(
              e['monthlyTransactionId'].toString(),
              e['monthlyTransactionName'],
              e['monthlyTransactionAmount'],
              e['monthlyTransactionDate'],
              e['categoryId'],
              e['subCategoryId'],
              e['includeFlg'],
              e['monthlyTransactionSign'],
              e['categoryName'],
              e['subCategoryName']));
        });
      }
    });
    return resultList;
  }

  static void saveFixed(List<dynamic> resultList, String param) async {
    await db
        .collection('monthlyTransactionData')
        .doc('monthlyTransactionData$param')
        .set({'data': resultList});
  }

  static void deleteFixed() async {
    await db.collection('monthlyTransactionData').delete();
  }
}
