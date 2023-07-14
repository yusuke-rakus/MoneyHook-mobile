import 'package:localstore/localstore.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';

class SavingStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteMonthlySavingData();
    deleteSavingAmountForTarget();
    deleteTotalSaving();
  }

  /// 【貯金一覧画面】データ
  static Future<List<savingClass>> getMonthlySavingData(
      String param, Function setLoading) async {
    setLoading();

    final id = 'monthlySavingData$param';
    List<savingClass> resultList = [];

    await db.collection('monthlySavingData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(savingClass.setFields(
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
      List<savingClass> resultList, String param) async {
    await db
        .collection('monthlySavingData')
        .doc('monthlySavingData$param')
        .set({'data': resultList.map((e) => e.getSavingJson()).toList()});
  }

  static void deleteMonthlySavingData() async {
    await db.collection('monthlySavingData').delete();
  }

  /// 【貯金総額画面】貯金目標毎の総額データ
  static Future<List<savingTargetClass>> getSavingAmountForTarget(
      String param, Function setLoading) async {
    setLoading();

    final id = 'savingAmountForTargetData$param';
    List<savingTargetClass> resultList = [];

    await db
        .collection('savingAmountForTargetData')
        .doc(id)
        .get()
        .then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(savingTargetClass.setFields(
            e['savingTargetId'],
            e['savingTargetName'],
            e['targetAmount'],
            e['totalSavedAmount'],
            e['savingCount'],
          ));
        });
      }
    }).then((value) => setLoading());
    return resultList;
  }

  static void saveSavingAmountForTarget(
      List<savingTargetClass> resultList, String param) async {
    await db
        .collection('savingAmountForTargetData')
        .doc('savingAmountForTargetData$param')
        .set({
      'data': resultList.map((e) => e.getSavingAmountForTargetJson()).toList()
    });
  }

  static void deleteSavingAmountForTarget() async {
    await db.collection('savingAmountForTargetData').delete();
  }

  /// 【貯金総額画面】貯金総額データ
  static Future<Map<String, dynamic>> getTotalSaving(
      String param, Function setTotalSaving) async {
    final id = 'totalSavingData$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};
    List<savingTargetClass> resultList = [];

    await db.collection('totalSavingData').doc(id).get().then((value) {
      if (value != null) {
        value['savingDataList'].forEach((e) {
          resultList.add(savingTargetClass.setChartFields(
              e['monthlyTotalSavingAmount'], DateTime.parse(e['savingMonth'])));
        });

        resultMap['totalSavingAmount'] = value['totalSavingAmount'];
        resultMap['savingDataList'] = resultList;
      }
    });
    return resultMap;
  }

  static void saveTotalSaving(int totalSavingAmount,
      List<savingTargetClass> resultList, String param) async {
    await db.collection('totalSavingData').doc('totalSavingData$param').set({
      'totalSavingAmount': totalSavingAmount,
      'savingDataList': resultList.map((e) => e.getTotalSavingJson()).toList()
    });
  }

  static void deleteTotalSaving() async {
    await db.collection('totalSavingData').delete();
  }
}
