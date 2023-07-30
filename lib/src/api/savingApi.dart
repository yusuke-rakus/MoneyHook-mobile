import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/api/validation/savingValidation.dart';
import 'package:money_hooks/src/searchStorage/savingStorage.dart';

import '../class/savingClass.dart';
import '../class/savingTargetClass.dart';
import '../env/envClass.dart';

class SavingApi {
  static String rootURI = '${Api.rootURI}/saving';
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<void> getMonthlySavingData(
      envClass env, Function setLoading, Function setSavingList) async {
    setLoading();
    await Future(() async {
      try {
        Response res = await Api.dio
            .post('$rootURI/getMonthlySavingData', data: env.getJson());
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
          SavingStorage.saveMonthlySavingData(
              resultList, env.getJson().toString());
        }
      } on DioError catch (e) {
        Api.errorMessage(e);
      } finally {
        setLoading();
      }
    });
  }

  static Future<void> getSavingAmountForTarget(
      String userId, Function setLoading, Function setSavingTargetList) async {
    setLoading();
    await Future(() async {
      try {
        Response res =
            await Api.dio.post('$rootURI/getSavingAmountForTarget', data: {
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
          SavingStorage.saveSavingAmountForTarget(resultList, userId);
        }
      } on DioError catch (e) {
        Api.errorMessage(e);
      } finally {
        setLoading();
      }
    });
  }

  static Future<void> getTotalSaving(
      envClass env, Function setTotalSaving) async {
    await Future(() async {
      try {
        Response res =
            await Api.dio.post('$rootURI/getTotalSaving', data: env.getJson());
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
          SavingStorage.saveTotalSaving(res.data['totalSavingAmount'],
              resultList, env.getJson().toString());
        }
      } on DioError catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// 貯金の追加
  static Future<void> addSaving(savingClass saving, Function backNavigation,
      Function setDisable, Function setSnackBar) async {
    setDisable();
    if (savingValidation.checkSaving(saving)) {
      return;
    }

    await Future(() async {
      try {
        Response res = await Api.dio
            .post('$rootURI/addSaving', data: saving.getSavingJson());
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          SavingStorage.allDeleteWithParam(saving.userId, saving.savingDate);
          backNavigation();
        }
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
        setDisable();
      }
    });
  }

  /// 貯金の編集
  static Future<void> editSaving(savingClass saving, Function backNavigation,
      Function setDisable, Function setSnackBar) async {
    setDisable();
    if (savingValidation.checkSaving(saving)) {
      return;
    }

    await Future(() async {
      try {
        Response res = await Api.dio
            .post('$rootURI/editSaving', data: saving.getSavingJson());
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          SavingStorage.allDeleteWithParam(saving.userId, saving.savingDate);
          backNavigation();
        }
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
        setDisable();
      }
    });
  }

  /// 貯金の削除
  static Future<void> deleteSaving(
      envClass env,
      savingClass saving,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    await Future(() async {
      try {
        Response res = await Api.dio.post('$rootURI/deleteSaving',
            data: {'userId': env.userId, 'savingId': saving.savingId});
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          SavingStorage.allDeleteWithParam(env.userId, saving.savingDate);
          backNavigation();
        }
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
        setDisable();
      }
    });
  }

  /// レコメンドリストの取得
  static Future<void> getFrequentSavingName(
      envClass env, Function setRecommendList) async {
    await Future(() async {
      try {
        Response res =
            await Api.dio.post('$rootURI/getFrequentSavingName', data: {
          'userId': env.userId,
        });
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<String> resultList = [];
          res.data['savingList'].forEach((value) {
            resultList.add(value['savingName']);
          });
          setRecommendList(resultList);
        }
      } on DioError catch (e) {
        Api.errorMessage(e);
      }
    });
  }
}
