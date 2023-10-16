import 'package:localstore/localstore.dart';

import '../class/savingTargetClass.dart';

class SavingTargetStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteSavingTargetData();
    deleteDeletedSavingTargetData();
  }

  /// 【貯金目標一覧取得】データ
  static Future<List<SavingTargetClass>> getSavingTargetData(
      Function setSavingTargetList, String param) async {
    final id = 'savingTargetData$param';
    List<SavingTargetClass> resultList = [];

    await db.collection('savingTargetData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(SavingTargetClass.setTargetFields(
              e['savingTargetId'], e['savingTargetName']));
        });
      }
    });
    return resultList;
  }

  static void saveSavingTargetData(
      List<SavingTargetClass> resultList, String param) async {
    await db
        .collection('savingTargetData')
        .doc('savingTargetData$param')
        .set({'data': resultList.map((e) => e.getSavingTargetJson()).toList()});
  }

  static void deleteSavingTargetData() async {
    await db.collection('savingTargetData').delete();
  }

  /// 【貯金目標一覧取得】データ
  static Future<List<SavingTargetClass>> getDeletedSavingTargetData(
      Function setSavingTargetList, String param) async {
    final id = 'DeletedSavingTargetData$param';
    List<SavingTargetClass> resultList = [];

    await db.collection('DeletedSavingTargetData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(SavingTargetClass.setTargetFields(
              e['savingTargetId'], e['savingTargetName']));
        });
      }
    });
    return resultList;
  }

  static void saveDeletedSavingTargetData(
      List<SavingTargetClass> resultList, String param) async {
    await db
        .collection('DeletedSavingTargetData')
        .doc('DeletedSavingTargetData$param')
        .set({'data': resultList.map((e) => e.getSavingTargetJson()).toList()});
  }

  static void deleteDeletedSavingTargetData() async {
    await db.collection('DeletedSavingTargetData').delete();
  }
}
