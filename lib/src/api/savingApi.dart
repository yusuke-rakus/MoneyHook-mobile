import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/api/validation/savingValidation.dart';

import '../class/savingClass.dart';
import '../class/savingTargetClass.dart';
import '../env/envClass.dart';

class savingApi {
  static String rootURI = '${Api.rootURI}/saving';
  static Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<void> getMonthlySavingData(
      envClass env, Function setLoading, Function setSavingList) async {
    setLoading();
    await Future(() async {
      Response res =
          await dio.post('$rootURI/getMonthlySavingData', data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingClass> resultList = [];
        num resultAmount = 0;
        res.data['savingList'].forEach((value) {
          resultList.add(savingClass.setFields(
              value['savingDate'],
              value['savingName'],
              value['savingId'],
              value['savingAmount'],
              value['savingTargetId'],
              value['savingTargetName']));
        });
        for (var e in resultList) {
          resultAmount += e.savingAmount;
        }
        setSavingList(resultList, resultAmount);
      }
    });
    setLoading();
  }

  static Future<void> getSavingAmountForTarget(
      String userId, Function setLoading, Function setSavingTargetList) async {
    setLoading();
    await Future(() async {
      Response res = await dio.post('$rootURI/getSavingAmountForTarget', data: {
        'userId': userId,
      });
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingTargetClass> resultList = [];
        res.data['savingTargetList'].forEach((value) {
          resultList.add(savingTargetClass.setFields(
            value['savingTargetId'],
            value['savingTargetName'],
            value['targetAmount'],
            value['totalSavedAmount'],
            value['savingCount'],
          ));
        });
        setSavingTargetList(resultList);
      }
    });
    setLoading();
  }

  static Future<void> getTotalSaving(
      envClass env, Function setTotalSaving) async {
    await Future(() async {
      Response res =
          await dio.post('$rootURI/getTotalSaving', data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingTargetClass> resultList = [];
        res.data['savingDataList'].forEach((value) {
          resultList.add(savingTargetClass.setChartFields(
              value['monthlyTotalSavingAmount'],
              DateFormat('yyyy-MM-dd').parse(value['savingMonth'])));
        });
        setTotalSaving(res.data['totalSavingAmount'], resultList);
      }
    });
  }

  /// 貯金の追加
  static Future<void> addSaving(savingClass saving, Function backNavigation,
      Function setDisable, Function setErrorMessage) async {
    setDisable();
    setErrorMessage('');
    if (savingValidation.checkSaving(saving)) {
      return;
    }

    await Future(() async {
      Response res =
          await dio.post('$rootURI/addSaving', data: saving.getSavingJson());
      if (res.data['status'] == 'error') {
        // 失敗
        setErrorMessage(res.data['message']);
        setDisable();
      } else {
        // 成功
        backNavigation();
      }
    });
  }

  /// 貯金の編集
  static Future<void> editSaving(savingClass saving, Function backNavigation,
      Function setDisable, Function setErrorMessage) async {
    setDisable();
    setErrorMessage('');
    if (savingValidation.checkSaving(saving)) {
      return;
    }

    await Future(() async {
      Response res =
          await dio.post('$rootURI/editSaving', data: saving.getSavingJson());
      if (res.data['status'] == 'error') {
        // 失敗
        setErrorMessage(res.data['message']);
        setDisable();
      } else {
        // 成功
        backNavigation();
      }
    });
  }

  /// 貯金の削除
  static Future<void> deleteSaving(
      envClass env,
      savingClass saving,
      Function backNavigation,
      Function setDisable,
      Function setErrorMessage) async {
    setDisable();
    setErrorMessage('');
    await Future(() async {
      Response res = await dio.post('$rootURI/deleteSaving',
          data: {'userId': env.userId, 'savingId': saving.savingId});
      if (res.data['status'] == 'error') {
        // 失敗
        setErrorMessage(res.data['message']);
        setDisable();
      } else {
        // 成功
        backNavigation();
      }
    });
  }
}
