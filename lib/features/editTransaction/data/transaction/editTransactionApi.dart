import 'package:dio/dio.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/data/data/transaction/commonTransactionStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryStorage.dart';
import 'package:money_hooks/features/editTransaction/data/transaction/transactionValidation.dart';
import 'package:money_hooks/features/settings/data/hideSubCategory/hideSubCategoryStorage.dart';

class EditTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  /// 取引の追加
  static Future<void> addTransaction(
      TransactionClass transaction,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    if (TransactionValidation.checkTransaction(transaction)) {
      setDisable();
      return;
    }

    Options? option = await Api.getHeader();
    try {
      Response res = await Api.dio.post('$rootURI/addTransaction',
          data: {'transaction': transaction.getTransactionJson()},
          options: option);
      if (res.statusCode != 200) {
        // 失敗
        setSnackBar(res.data['message']);
        setDisable();
      } else {
        // 成功
        CommonTranTransactionStorage.allDeleteWithParam(
            transaction.userId, transaction.transactionDate);
        if (transaction.subCategoryId == null) {
          HideSubCategoryStorage.deleteCategoryWithSubCategoryList();
          EditTranCategoryStorage.deleteSubCategoryListWithParam(
              transaction.categoryId.toString());
        }
        backNavigation(isUpdate: false);
      }
    } on DioException catch (e) {
      setDisable();
      setSnackBar(Api.errorMessage(e));
    }
  }

  /// 取引の編集
  static Future<void> editTransaction(
      TransactionClass transaction,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    if (TransactionValidation.checkTransaction(transaction)) {
      setDisable();
      return;
    }

    Options? option = await Api.getHeader();
    try {
      Response res = await Api.dio.patch('$rootURI/editTransaction',
          data: {'transaction': transaction.getTransactionJson()},
          options: option);
      if (res.statusCode != 200) {
        // 失敗
        setSnackBar(res.data['message']);
        setDisable();
      } else {
        // 成功
        CommonTranTransactionStorage.allDeleteWithParam(
            transaction.userId, transaction.transactionDate);
        if (transaction.subCategoryId == null) {
          HideSubCategoryStorage.deleteCategoryWithSubCategoryList();
          EditTranCategoryStorage.deleteSubCategoryListWithParam(
              transaction.categoryId.toString());
        }
        backNavigation(isUpdate: true);
      }
    } on DioException catch (e) {
      setDisable();
      setSnackBar(Api.errorMessage(e));
    }
  }

  /// 取引の削除
  static Future<void> deleteTransaction(
      EnvClass env,
      TransactionClass transaction,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    Options? option = await Api.getHeader();
    try {
      setDisable();
      Response res = await Api.dio.delete(
          '$rootURI/deleteTransaction/${transaction.transactionId}',
          options: option);
      if (res.statusCode != 200) {
        // 失敗
        setSnackBar(res.data['message']);
        setDisable();
      } else {
        // 成功
        CommonTranTransactionStorage.allDeleteWithParam(
            env.userId, transaction.transactionDate);
        backNavigation(isUpdate: true);
      }
    } on DioException catch (e) {
      setDisable();
      setSnackBar(Api.errorMessage(e));
    }
  }
}
