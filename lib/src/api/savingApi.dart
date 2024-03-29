import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/api/validation/savingValidation.dart';
import 'package:money_hooks/src/searchStorage/savingStorage.dart';

import '../class/savingClass.dart';
import '../class/savingTargetClass.dart';
import '../env/envClass.dart';

class SavingApi {
  static String rootURI = '${Api.rootURI}/saving';

  static Future<void> getMonthlySavingData(envClass env, Function setLoading,
      Function setSnackBar, Function setSavingList) async {
    setLoading();
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getMonthlySavingData',
            data: env.getJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<SavingClass> resultList = [];
          num resultAmount = 0;
          res.data['savingList'].forEach((value) {
            resultList.add(SavingClass.setFields(
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
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  static Future<void> getSavingAmountForTarget(
      String userId, setSnackBar, Function setSavingTargetList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getSavingAmountForTarget',
            data: {'userId': userId}, options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<SavingTargetClass> resultList = [];
          res.data['savingTargetList'].forEach((value) {
            resultList.add(SavingTargetClass.setFields(
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
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  static Future<void> getTotalSaving(
      envClass env, Function setTotalSaving) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getTotalSaving',
            data: env.getJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<SavingTargetClass> resultList = [];
          res.data['savingDataList'].forEach((value) {
            resultList.add(SavingTargetClass.setChartFields(
                value['monthlyTotalSavingAmount'],
                DateFormat('yyyy-MM-dd').parse(value['savingMonth'])));
          });
          resultList = List.from(resultList.reversed);
          setTotalSaving(res.data['totalSavingAmount'], resultList);
          SavingStorage.saveTotalSaving(res.data['totalSavingAmount'],
              resultList, env.getJson().toString());
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// 貯金の追加
  static Future<void> addSaving(SavingClass saving, Function backNavigation,
      Function setDisable, Function setSnackBar) async {
    setDisable();
    if (savingValidation.checkSaving(saving)) {
      setDisable();
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/addSaving',
            data: saving.getSavingJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          SavingStorage.allDeleteWithParam(saving.userId, saving.savingDate);
          backNavigation();
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
        setDisable();
      }
    });
  }

  /// 貯金の編集
  static Future<void> editSaving(SavingClass saving, Function backNavigation,
      Function setDisable, Function setSnackBar) async {
    setDisable();
    if (savingValidation.checkSaving(saving)) {
      setDisable();
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/editSaving',
            data: saving.getSavingJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          SavingStorage.allDeleteWithParam(saving.userId, saving.savingDate);
          backNavigation();
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
        setDisable();
      }
    });
  }

  /// 貯金の削除
  static Future<void> deleteSaving(
      envClass env,
      SavingClass saving,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/deleteSaving',
            data: {'userId': env.userId, 'savingId': saving.savingId},
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          SavingStorage.allDeleteWithParam(env.userId, saving.savingDate);
          backNavigation();
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
        setDisable();
      }
    });
  }

  /// レコメンドリストの取得
  static Future<void> getFrequentSavingName(
      envClass env, Function setRecommendList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getFrequentSavingName',
            data: {
              'userId': env.userId,
            },
            options: option);
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
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }
}
