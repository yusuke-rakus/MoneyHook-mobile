import 'package:dio/dio.dart';
import 'package:money_hooks/src/api/validation/monthlyTransactionValidation.dart';
import 'package:money_hooks/src/class/monthlyTransactionClass.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/searchStorage/monthlyTransactionStorage.dart';

import '../searchStorage/categoryStorage.dart';
import 'api.dart';

class MonthlyTransactionApi {
  static String rootURI = '${Api.rootURI}/fixed';

  /// 月次取引の取得
  static Future<void> getFixed(envClass env, Function setMonthlyTransactionList,
      Function setLoading, Function setSnackBar) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getFixed',
            data: env.getUserJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
        } else {
          // 成功
          List<MonthlyTransactionClass> resultList = [];
          res.data['monthlyTransactionList'].forEach((value) {
            resultList.add(MonthlyTransactionClass.setFields(
              value['monthlyTransactionId'].toString(),
              value['monthlyTransactionName'],
              value['monthlyTransactionAmount'],
              value['monthlyTransactionDate'],
              value['categoryId'],
              value['subCategoryId'],
              value['includeFlg'],
              value['monthlyTransactionSign'],
              value['categoryName'],
              value['subCategoryName'],
            ));
          });
          setMonthlyTransactionList(resultList);
          MonthlyTransactionStorage.saveFixed(
              res.data['monthlyTransactionList'], env.getUserJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  /// 月次取引の追加
  static Future<void> editTransaction(
      MonthlyTransactionClass monthlyTransaction,
      Function backNavigation,
      Function setSnackBar,
      Function setDisable) async {
    setDisable();
    if (monthlyTransactionValidation
        .checkMonthlyTransaction(monthlyTransaction)) {
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/editOneFixed',
            data: monthlyTransaction.convertEditMonthlyTranJson(),
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setDisable();
          setSnackBar(res.data['message']);
        } else {
          // 成功
          if (monthlyTransaction.subCategoryId == null) {
            CategoryStorage.deleteSubCategoryListWithParam(
                monthlyTransaction.categoryId.toString());
          }
        }
        backNavigation();
      } on DioException catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 月次取引の削除
  static Future<void> deleteMonthlyTransaction(
      MonthlyTransactionClass monthlyTransaction,
      Function backNavigation,
      Function setSnackBar,
      Function setDisable) async {
    setDisable();
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/deleteFixedFromTable',
            data: monthlyTransaction.convertDeleteMonthlyTranJson(),
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setDisable();
          setSnackBar(res.data['message']);
        } else {
          // 成功
        }
        setSnackBar(res.data['message']);
        backNavigation();
      } on DioException catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
