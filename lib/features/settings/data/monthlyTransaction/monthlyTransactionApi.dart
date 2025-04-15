import 'package:dio/dio.dart';
import 'package:money_hooks/common/class/monthlyTransactionClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryStorage.dart';
import 'package:money_hooks/features/settings/data/monthlyTransaction/monthlyTransactionValidation.dart';

class MonthlyTransactionApi {
  static String rootURI = '${Api.rootURI}/fixed';

  /// 月次取引の追加
  static Future<void> addTransaction(
      MonthlyTransactionClass monthlyTransaction,
      Function backNavigation,
      Function setSnackBar,
      Function setDisable) async {
    setDisable();
    if (MonthlyTransactionValidation.checkMonthlyTransaction(
        monthlyTransaction)) {
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
            EditTranCategoryStorage.deleteSubCategoryListWithParam(
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
    if (MonthlyTransactionValidation.checkMonthlyTransaction(
        monthlyTransaction)) {
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
            EditTranCategoryStorage.deleteSubCategoryListWithParam(
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
