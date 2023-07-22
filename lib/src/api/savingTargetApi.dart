import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/api/validation/savingTargetValidation.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';
import 'package:money_hooks/src/searchStorage/savingStorage.dart';
import 'package:money_hooks/src/searchStorage/savingTargetStorage.dart';

import '../env/envClass.dart';

class SavingTargetApi {
  static String rootURI = '${Api.rootURI}/savingTarget';
  static Dio dio = Dio();
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  /// 貯金目標の取得
  static Future<void> getSavingTargetList(
      Function setSavingTargetList, String userId) async {
    await Future(() async {
      Response res = await dio
          .post('$rootURI/getSavingTargetList', data: {'userId': userId});
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingTargetClass> resultList = [
          savingTargetClass.setTargetFields(null, 'なし')
        ];
        res.data['savingTarget'].forEach((value) {
          resultList.add(savingTargetClass.setTargetFields(
              value['savingTargetId'], value['savingTargetName']));
        });
        setSavingTargetList(resultList);
        SavingTargetStorage.saveSavingTargetData(resultList, userId);
      }
    });
  }

  /// 貯金目標の追加
  static Future<void> addSavingTarget(
      savingTargetClass savingTarget,
      Function backNavigation,
      Function setDisable,
      Function setErrorMessage) async {
    setDisable();
    setErrorMessage('');
    // バリデーション
    if (savingTargetValidation.checkSavingTarget(savingTarget)) {
      return;
    }

    await Future(() async {
      Response res = await dio.post('$rootURI/addSavingTarget',
          data: savingTarget.getSavingTargetJson());
      if (res.data['status'] == 'error') {
        // 失敗
        setDisable();
        setErrorMessage(res.data['message']);
      } else {
        // 成功
        backNavigation();
        SavingTargetStorage.allDelete();
      }
    });
  }

  /// 貯金目標の編集
  static Future<void> editSavingTarget(
      savingTargetClass savingTarget,
      Function backNavigation,
      Function setDisable,
      Function setErrorMessage) async {
    setDisable();
    setErrorMessage('');
    // バリデーション
    if (savingTargetValidation.checkSavingTarget(savingTarget)) {
      return;
    }

    await Future(() async {
      Response res = await dio.post('$rootURI/editSavingTarget',
          data: savingTarget.getSavingTargetJson());
      if (res.data['status'] == 'error') {
        // 失敗
        setDisable();
        setErrorMessage(res.data['message']);
      } else {
        // 成功
        backNavigation();
        SavingTargetStorage.allDelete();
      }
    });
  }

  /// 貯金目標の削除
  static Future<void> deleteSavingTarget(
      envClass env,
      savingTargetClass savingTarget,
      Function backNavigation,
      Function setDisable,
      Function setErrorMessage) async {
    setDisable();
    setErrorMessage('');
    await Future(() async {
      Response res = await dio.post('$rootURI/deleteSavingTarget', data: {
        'userId': env.userId,
        'savingTargetId': savingTarget.savingTargetId
      });
      if (res.data['status'] == 'error') {
        // 失敗
        setDisable();
        setErrorMessage(res.data['message']);
      } else {
        // 成功
        backNavigation();
        SavingTargetStorage.allDelete();
      }
    });
  }

  /// 削除済み貯金目標を取得
  static Future<void> getDeletedSavingTarget(
      Function setSavingTargetList, String userId) async {
    await Future(() async {
      Response res = await dio
          .post('$rootURI/getDeletedSavingTarget', data: {'userId': userId});
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<savingTargetClass> resultList = [];
        res.data['savingTarget'].forEach((value) {
          resultList.add(savingTargetClass.setTargetFields(
              value['savingTargetId'], value['savingTargetName']));
        });
        setSavingTargetList(resultList);
        SavingTargetStorage.saveDeletedSavingTargetData(resultList, userId);
      }
    });
  }

  /// 貯金目標を削除(物理)
  static Future<void> deleteSavingTargetFromTable(
      envClass env,
      savingTargetClass savingTarget,
      Function setMessage,
      Function reloadList) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/deleteSavingTargetFromTable',
          data: {
            'userId': env.userId,
            'savingTargetId': savingTarget.savingTargetId
          });
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        reloadList(savingTarget);
        SavingTargetStorage.deleteDeletedSavingTargetData();
      }
      setMessage(res.data['message']);
    });
  }

  /// 貯金目標を戻す
  static Future<void> returnSavingTarget(
      envClass env,
      savingTargetClass savingTarget,
      Function setMessage,
      Function reloadList) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/returnSavingTarget', data: {
        'userId': env.userId,
        'savingTargetId': savingTarget.savingTargetId
      });
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        reloadList(savingTarget);
        SavingTargetStorage.allDelete();
        SavingStorage.deleteSavingAmountForTarget();
      }
      setMessage(res.data['message']);
    });
  }
}
