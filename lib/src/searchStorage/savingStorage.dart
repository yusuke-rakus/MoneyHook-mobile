import 'package:localstore/localstore.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';

import '../env/envClass.dart';

class SavingStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteMonthlySavingData();
    deleteSavingAmountForTarget();
    deleteTotalSaving();
  }

  /// ストレージ全削除(月指定)
  static void allDeleteWithParam(String userId, String savingDate) {
    deleteMonthlySavingDataWithParam(userId, savingDate);
    deleteSavingAmountForTargetWithParam(userId);
    deleteTotalSavingWithParam(userId, savingDate);
  }

  /// 【貯金一覧画面】データ
  static Future<List<SavingClass>> getMonthlySavingData(
      String param, Function setLoading) async {
    setLoading();

    final id = 'monthlySavingData$param';
    List<SavingClass> resultList = [];

    await db.collection('monthlySavingData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(SavingClass.setFields(
              e['savingDate'],
              e['savingName'],
              e['savingId'],
              e['savingAmount'],
              e['savingTargetId'],
              e['savingTargetName']));
        });
      }
    }).then((value) => setLoading());
    return resultList;
  }

  static void saveMonthlySavingData(
      List<SavingClass> resultList, String param) async {
    await db
        .collection('monthlySavingData')
        .doc('monthlySavingData$param')
        .set({'data': resultList.map((e) => e.getSavingJson()).toList()});
  }

  static void deleteMonthlySavingData() async {
    await db.collection('monthlySavingData').delete();
  }

  static void deleteMonthlySavingDataWithParam(
      String userId, String savingDate) async {
    envClass env = envClass.initNew(userId, savingDate);
    final id = 'monthlySavingData${env.getJson()}';
    await db.collection('monthlySavingData').doc(id).delete();
  }

  /// 【貯金総額画面】貯金目標毎の総額データ
  static Future<List<SavingTargetClass>> getSavingAmountForTarget(
      String param) async {
    final id = 'savingAmountForTargetData$param';
    List<SavingTargetClass> resultList = [];

    await db
        .collection('savingAmountForTargetData')
        .doc(id)
        .get()
        .then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(SavingTargetClass.setFields(
              e['savingTargetId'],
              e['savingTargetName'],
              e['targetAmount'],
              e['totalSavedAmount'],
              e['savingCount']));
        });
      }
    });
    return resultList;
  }

  static void saveSavingAmountForTarget(
      List<SavingTargetClass> resultList, String param) async {
    await db
        .collection('savingAmountForTargetData')
        .doc('savingAmountForTargetData$param')
        .set({
      'data': resultList.map((e) => e.getSavingAmountForTargetJson()).toList()
    });
  }

  static Future<void> deleteSavingAmountForTarget() async {
    await db.collection('savingAmountForTargetData').delete();
  }

  static void deleteSavingAmountForTargetWithParam(String userId) async {
    final id = 'savingAmountForTargetData$userId';
    await db.collection('savingAmountForTargetData').doc(id).delete();
  }

  /// 【貯金総額画面】貯金総額データ
  static Future<Map<String, dynamic>> getTotalSaving(
      String param, Function setTotalSaving) async {
    final id = 'totalSavingData$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};
    List<SavingTargetClass> resultList = [];

    await db.collection('totalSavingData').doc(id).get().then((value) {
      if (value != null) {
        value['savingDataList'].forEach((e) {
          resultList.add(SavingTargetClass.setChartFields(
              e['monthlyTotalSavingAmount'], DateTime.parse(e['savingMonth'])));
        });

        resultMap['totalSavingAmount'] = value['totalSavingAmount'];
        resultMap['savingDataList'] = resultList;
      }
    });
    return resultMap;
  }

  static void saveTotalSaving(int totalSavingAmount,
      List<SavingTargetClass> resultList, String param) async {
    await db.collection('totalSavingData').doc('totalSavingData$param').set({
      'totalSavingAmount': totalSavingAmount,
      'savingDataList': resultList.map((e) => e.getTotalSavingJson()).toList()
    });
  }

  static void deleteTotalSaving() async {
    await db.collection('totalSavingData').delete();
  }

  static void deleteTotalSavingWithParam(
      String userId, String savingDate) async {
    envClass env = envClass.initNew(userId, savingDate);
    final id = 'totalSavingData${env.getJson()}';
    await db.collection('totalSavingData').doc(id).delete();
  }
}
