import 'package:dio/dio.dart';
import 'package:money_hooks/src/api/validation/monthlyTransactionValidation.dart';
import 'package:money_hooks/src/class/monthlyTransactionClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

import 'api.dart';

class monthlyTransactionApi {
  static String rootURI = '${Api.rootURI}/fixed';
  static Dio dio = Dio();

  /// 月次取引の取得
  static Future<void> getFixed(envClass env, Function setMonthlyTransactionList,
      Function setLoading, Function setErrorMessage) async {
    await Future(() async {
      Response res =
          await dio.post('$rootURI/getFixed', data: env.getUserJson());
      if (res.data['status'] == 'error') {
        // 失敗
        setErrorMessage(res.data['message']);
      } else {
        // 成功
        List<monthlyTransactionClass> resultList = [];
        res.data['monthlyTransactionList'].forEach((value) {
          resultList.add(monthlyTransactionClass.setFields(
            value['monthlyTransactionId'].toString(),
            value['monthlyTransactionName'],
            value['monthlyTransactionAmount'],
            value['monthlyTransactionDate'],
            value['categoryId'].toString(),
            value['subCategoryId'].toString(),
            value['includeFlg'],
            value['monthlyTransactionSign'],
            value['categoryName'],
            value['subCategoryName'],
          ));
        });
        setMonthlyTransactionList(resultList);
      }
      setLoading();
    });
  }

  /// 月次取引の追加
  static Future<void> editTransaction(
      monthlyTransactionClass monthlyTransaction,
      Function backNavigation,
      Function setErrorMessage,
      Function setDisable) async {
    setDisable();
    if (monthlyTransactionValidation
        .checkMonthlyTransaction(monthlyTransaction)) {
      return;
    }

    await Future(() async {
      Response res = await dio.post('$rootURI/editOneFixed',
          data: monthlyTransaction.convertEditMonthlyTranJson());
      if (res.data['status'] == 'error') {
        // 失敗
        setErrorMessage(res.data['message']);
      } else {
        // 成功
      }
      backNavigation();
    });
  }

  /// 月次取引の削除
  static Future<void> deleteMonthlyTransaction(
      monthlyTransactionClass monthlyTransaction,
      Function backNavigation,
      Function setErrorMessage,
      Function setDisable) async {
    setDisable();
    await Future(() async {
      Response res = await dio.post('$rootURI/deleteFixedFromTable',
          data: monthlyTransaction.convertDeleteMonthlyTranJson());
      if (res.data['status'] == 'error') {
        // 失敗
        setErrorMessage(res.data['message']);
      } else {
        // 成功
      }
      backNavigation();
    });
  }
}
