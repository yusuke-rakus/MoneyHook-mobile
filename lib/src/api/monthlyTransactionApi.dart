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
        Response res = await Api.dio.get('$rootURI/getFixed', options: option);
        if (res.statusCode != 200) {
          // 失敗
          setSnackBar(res.data['message']);
        } else {
          // 成功
          List<MonthlyTransactionClass> resultList = [];
          res.data['monthly_transaction_list'].forEach((value) {
            resultList.add(MonthlyTransactionClass.setFields(
              value['monthly_transaction_id'],
              value['monthly_transaction_name'],
              value['monthly_transaction_amount'],
              value['monthly_transaction_date'],
              value['category_id'],
              value['sub_category_id'],
              value['monthly_transaction_sign'],
              value['category_name'],
              value['sub_category_name'],
              value['payment_id'],
            ));
          });
          setMonthlyTransactionList(resultList);
          MonthlyTransactionStorage.saveFixed(
              res.data['monthly_transaction_list'],
              env.getUserJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  /// 月次取引の追加
  static Future<void> addTransaction(
      MonthlyTransactionClass monthlyTransaction,
      Function backNavigation,
      Function setSnackBar,
      Function setDisable) async {
    setDisable();
    if (monthlyTransactionValidation
        .checkMonthlyTransaction(monthlyTransaction)) {
      setDisable();
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/addFixed',
            data: monthlyTransaction.convertEditMonthlyTranJson(),
            options: option);
        if (res.statusCode != 200) {
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

  /// 月次取引の編集
  static Future<void> editTransaction(
      MonthlyTransactionClass monthlyTransaction,
      Function backNavigation,
      Function setSnackBar,
      Function setDisable) async {
    setDisable();
    if (monthlyTransactionValidation
        .checkMonthlyTransaction(monthlyTransaction)) {
      setDisable();
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.patch('$rootURI/editFixed',
            data: monthlyTransaction.convertEditMonthlyTranJson(),
            options: option);
        if (res.statusCode != 200) {
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
        Response res = await Api.dio.delete(
            '$rootURI/deleteFixed/${monthlyTransaction.monthlyTransactionId}',
            options: option);
        if (res.statusCode != 200) {
          // 失敗
          setDisable();
          setSnackBar("失敗しました");
        } else {
          // 成功
        }
        setSnackBar("削除に成功しました");
        backNavigation();
      } on DioException catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
