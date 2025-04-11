import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/env/envClass.dart';

class HomeTransactionStorage {
  static final db = Localstore.instance;

  /// 【ホーム画面】データ
  static Future<Map<String, dynamic>> getHome(String param) async {
    final id = 'home_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('home_data').doc(id).get().then((value) {
      if (value != null) {
        resultMap['balance'] = value['balance'];
        resultMap['category_list'] = value['category_list'];
      }
    });
    return resultMap;
  }

  static void saveStorageHomeData(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('home_data')
        .doc('home_data$param')
        .set({'balance': balance, 'category_list': resultList});
  }

  static void deleteHomeData() async {
    await db.collection('home_data').delete();
  }

  static void deleteHomeDataWithParam(
      String userId, String transactionDate) async {
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'home_data${env.getJson()}';
    await db.collection('home_data').doc(id).delete();
  }
}
