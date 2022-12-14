import 'package:dio/dio.dart';
import 'package:money_hooks/src/api/validation/transactionValidation.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/env/envClass.dart';

import 'api.dart';

class transactionApi {
  static String rootURI = '${Api.rootURI}/transaction';
  static Dio dio = Dio();

  static Future<void> getHome(
      envClass env, Function setLoading, Function setHomeTransaction) async {
    setLoading();
    await Future(() async {
      Response res = await dio.post('$rootURI/getHome', data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        setHomeTransaction(res.data['balance'], res.data['categoryList']);
      }
      setLoading();
    });
  }

  static Future<void> getTimelineData(
      envClass env, Function setLoading, Function setTimelineData) async {
    setLoading();
    await Future(() async {
      Response res =
          await dio.post('$rootURI/getTimelineData', data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<transactionClass> resultList = [];
        res.data['transactionList'].forEach((value) {
          String transactionId = value['transactionId'].toString();
          String transactionDate = value['transactionDate'];
          int transactionSign = value['transactionSign'];
          String transactionAmount = value['transactionAmount'].toString();
          String transactionName = value['transactionName'];
          String categoryName = value['categoryName'];
          resultList.add(transactionClass.setTimelineFields(
              transactionId,
              transactionDate,
              transactionSign,
              int.parse(transactionAmount),
              transactionName,
              categoryName));
        });
        setTimelineData(resultList);
      }
      setLoading();
    });
  }

  static Future<void> getTimelineChart(
      envClass env, Function setTimelineChart) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/getMonthlySpendingData',
          data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<transactionClass> resultList = [];
        res.data['monthlyTotalAmountList'].reversed.forEach((value) {
          resultList.add(transactionClass.setTimelineChart(
              value['month'], value['totalAmount']));
        });
        setTimelineChart(resultList);
      }
    });
  }

  static Future<void> getMonthlyVariableData(
      envClass env, Function setLoading, Function setMonthlyVariable) async {
    setLoading();
    await Future(() async {
      Response res = await dio.post('$rootURI/getMonthlyVariableData',
          data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<Map<String, dynamic>> resultList = [];
        res.data['monthlyVariableList'].forEach((value) {
          Map<String, dynamic> categoryList = {
            'categoryName': value['categoryName'],
            'categoryTotalAmount': value['categoryTotalAmount'],
            'subCategoryList': value['subCategoryList']
          };
          resultList.add(categoryList);
        });
        setMonthlyVariable(res.data['totalVariable'].abs(), resultList);
      }
    });
    setLoading();
  }

  static Future<void> getMonthlyFixedIncome(
      envClass env, Function setMonthlyFixedIncome) async {
    await Future(() async {
      Response res =
          await dio.post('$rootURI/getMonthlyFixedIncome', data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        setMonthlyFixedIncome(
            res.data['disposableIncome'], res.data['monthlyFixedList']);
      }
    });
  }

  static Future<void> getMonthlyFixedSpending(envClass env, Function setLoading,
      Function setMonthlyFixedSpending) async {
    setLoading();
    await Future(() async {
      Response res = await dio.post('$rootURI/getMonthlyFixedSpending',
          data: env.getJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        setMonthlyFixedSpending(
            res.data['disposableIncome'], res.data['monthlyFixedList']);
      }
    });
    setLoading();
  }

  /// 取引の追加
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

  /// 取引の編集
  static Future<void> editTransaction(
      transactionClass transaction, Function backNavigation) async {
    if (transactionValidation.checkTransaction(transaction)) {
      return;
    }

    await Future(() async {
      Response res = await dio.post('$rootURI/editTransaction',
          data: transaction.getTransactionJson());
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        backNavigation();
      }
    });
  }

  /// 取引の削除
  static Future<void> deleteTransaction(envClass env,
      transactionClass transaction, Function backNavigation) async {
    await Future(() async {
      Response res = await dio.post('$rootURI/deleteTransaction', data: {
        'userId': env.userId,
        'transactionId': transaction.transactionId
      });
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        backNavigation();
      }
    });
  }

  /// レコメンドリストの取得
  static Future<void> getFrequentTransactionName(
      envClass env, Function setRecommendList) async {
    await Future(() async {
      Response res =
          await dio.post('$rootURI/getFrequentTransactionName', data: {
        'userId': env.userId,
      });
      if (res.data['status'] == 'error') {
        // 失敗
      } else {
        // 成功
        List<String> resultList = [];
        res.data['transactionList'].forEach((value) {
          resultList.add(value['transactionName']);
        });
        setRecommendList(resultList);
      }
    });
  }
}
