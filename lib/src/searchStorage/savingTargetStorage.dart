import 'package:localstore/localstore.dart';

import '../class/savingTargetClass.dart';

class SavingTargetStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteMonthlySavingData();
  }

  /// 【貯金目標一覧取得】データ
  static Future<List<savingTargetClass>> getSavingTargetData(
      Function setSavingTargetList, String param) async {
    final id = 'savingTargetData$param';
    List<savingTargetClass> resultList = [];

    await db.collection('savingTargetData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(savingTargetClass.setTargetFields(
              e['savingTargetId'], e['savingTargetName']));
        });
      }
    });
    return resultList;
  }

  static void saveSavingTargetData(
      List<savingTargetClass> resultList, String param) async {
    await db
        .collection('savingTargetData')
        .doc('savingTargetData$param')
        .set({'data': resultList.map((e) => e.getSavingTargetJson()).toList()});
  }

  static void deleteMonthlySavingData() async {
    await db.collection('savingTargetData').delete();
  }
}
