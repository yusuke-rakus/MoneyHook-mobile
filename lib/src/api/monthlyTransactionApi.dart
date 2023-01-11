import 'package:dio/dio.dart';
import 'package:money_hooks/src/api/validation/transactionValidation.dart';
import 'package:money_hooks/src/class/monthlyTransactionClass.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

import 'api.dart';

class monthlyTransactionApi {
  static String rootURI = '${Api.rootURI}/fixed';
  static Dio dio = Dio();

  /// 月次取引の取得
  static Future<void> getFixed(
      envClass env, Function setMonthlyTransactionList) async {
    await Future(() async {
      Response res =
          await dio.post('$rootURI/getFixed', data: env.getUserJson());
      if (res.data['status'] == 'error') {
        // 失敗
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
    });
  }

  /// 月次取引の追加
  static Future<void> addTransaction(
      transactionClass transaction, Function backNavigation) async {
    if (transactionValidation.checkTransaction(transaction)) {
      return;
    }

    await Future(() async {
      Response res = await dio.post('$rootURI/addTransaction',
          data: transaction.getTransactionJson());
      if (res.data['status'] == 'error') {
        // 失敗
        print('失敗');
      } else {
        // 成功
        backNavigation();
      }
    });
  }
}
