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
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  /// 貯金目標の取得
  static Future<void> getSavingTargetList(
      Function setSavingTargetList, String userId) async {
    await Future(() async {
      try {
        Response res = await Api.dio
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
      } on DioError catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// 貯金目標の追加
  static Future<void> addSavingTarget(
      savingTargetClass savingTarget,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    // バリデーション
    if (savingTargetValidation.checkSavingTarget(savingTarget)) {
      setDisable();
      return;
    }

    await Future(() async {
      try {
        Response res = await Api.dio.post('$rootURI/addSavingTarget',
            data: savingTarget.getSavingTargetJson());
        if (res.data['status'] == 'error') {
          // 失敗
          setDisable();
          setSnackBar(res.data['message']);
        } else {
          // 成功
          backNavigation();
          SavingTargetStorage.allDelete();
        }
      } on DioError catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 貯金目標の編集
  static Future<void> editSavingTarget(
      savingTargetClass savingTarget,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    // バリデーション
    if (savingTargetValidation.checkSavingTarget(savingTarget)) {
      setDisable();
      return;
    }

    await Future(() async {
      try {
        Response res = await Api.dio.post('$rootURI/editSavingTarget',
            data: savingTarget.getSavingTargetJson());
        if (res.data['status'] == 'error') {
          // 失敗
          setDisable();
          setSnackBar(res.data['message']);
        } else {
          // 成功
          backNavigation();
          SavingTargetStorage.allDelete();
        }
      } on DioError catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 貯金目標の削除
  static Future<void> deleteSavingTarget(
      envClass env,
      savingTargetClass savingTarget,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    await Future(() async {
      try {
        Response res = await Api.dio.post('$rootURI/deleteSavingTarget', data: {
          'userId': env.userId,
          'savingTargetId': savingTarget.savingTargetId
        });
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          backNavigation();
          SavingTargetStorage.allDelete();
        }
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
        setDisable();
      }
    });
  }

  /// 削除済み貯金目標を取得
  static Future<void> getDeletedSavingTarget(
      Function setSavingTargetList, Function setSnackBar, String userId) async {
    await Future(() async {
      try {
        Response res = await Api.dio
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
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 貯金目標を削除(物理)
  static Future<void> deleteSavingTargetFromTable(
      envClass env,
      savingTargetClass savingTarget,
      Function setSnackBar,
      Function reloadList) async {
    await Future(() async {
      try {
        Response res = await Api.dio
            .post('$rootURI/deleteSavingTargetFromTable', data: {
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
        setSnackBar(res.data['message']);
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 貯金目標を戻す
  static Future<void> returnSavingTarget(
      envClass env,
      savingTargetClass savingTarget,
      Function setSnackBar,
      Function reloadList) async {
    await Future(() async {
      try {
        Response res = await Api.dio.post('$rootURI/returnSavingTarget', data: {
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
        setSnackBar(res.data['message']);
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 貯金目標を並べ替え
  static Future<void> sortSavingTarget(envClass env,
      List<savingTargetClass> savingTargetList, Function setSnackBar) async {
    await Future(() async {
      try {
        Response res = await Api.dio.post('$rootURI/sortSavingTarget', data: {
          'userId': env.userId,
          'savingTargetList':
              savingTargetList.map((e) => e.getSortSavingJson()).toList()
        });
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          // 貯金目標リストを更新
          SavingStorage.deleteSavingAmountForTarget().then((value) =>
              SavingStorage.saveSavingAmountForTarget(
                  savingTargetList, env.userId));
          // 貯金目標リスト(貯金画面)を削除
          SavingTargetStorage.allDelete();
        }
        setSnackBar(res.data['message']);
      } on DioError catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
