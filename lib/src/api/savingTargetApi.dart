import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/api/validation/savingTargetValidation.dart';
import 'package:money_hooks/src/class/savingTargetClass.dart';

import '../env/envClass.dart';

class savingTargetApi {
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
        print('失敗');
        setDisable();
        setErrorMessage(res.data['message']);
      } else {
        // 成功
        print('成功');
        backNavigation();
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
      }
    });
  }
}
