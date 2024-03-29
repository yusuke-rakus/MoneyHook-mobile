import 'package:dio/dio.dart';
import 'package:money_hooks/src/api/validation/searchTransactionValidation.dart';
import 'package:money_hooks/src/api/validation/transactionValidation.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

import 'api.dart';

class transactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  static Future<void> getHome(envClass env, Function setLoading,
      Function setSnackBar, Function setHomeTransaction) async {
    setLoading();

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio
            .post('$rootURI/getHome', data: env.getJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          setHomeTransaction(res.data['balance'], res.data['categoryList']);
          TransactionStorage.saveStorageHomeData(res.data['balance'],
              res.data['categoryList'], env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  static Future<void> getTimelineData(envClass env, Function setLoading,
      Function setSnackBar, Function setTimelineData) async {
    setLoading();

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getTimelineData',
            data: env.getJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['transactionList'].forEach((value) {
            String transactionId = value['transactionId'].toString();
            String transactionDate = value['transactionDate'];
            int transactionSign = value['transactionSign'];
            String transactionAmount = value['transactionAmount'].toString();
            String transactionName = value['transactionName'];
            int categoryId = value['categoryId'];
            String categoryName = value['categoryName'];
            int subCategoryId = value['subCategoryId'];
            String subCategoryName = value['subCategoryName'];
            bool fixedFlg = value['fixedFlg'];
            resultList.add(TransactionClass.setTimelineFields(
                transactionId,
                transactionDate,
                transactionSign,
                int.parse(transactionAmount),
                transactionName,
                categoryId,
                categoryName,
                subCategoryId,
                subCategoryName,
                fixedFlg));
          });
          setTimelineData(resultList);
          TransactionStorage.saveStorageTimelineData(
              resultList, env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  static Future<void> getTimelineChart(
      envClass env, Function setTimelineChart) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getMonthlySpendingData',
            data: env.getJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['monthlyTotalAmountList'].reversed.forEach((value) {
            resultList.add(TransactionClass.setTimelineChart(
                value['month'], value['totalAmount']));
          });
          setTimelineChart(resultList);
          TransactionStorage.saveStorageTimelineChart(
              resultList, env.getJson().toString());
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  static Future<void> getMonthlyVariableData(envClass env, Function setLoading,
      setSnackBar, Function setMonthlyVariable) async {
    setLoading();
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getMonthlyVariableData',
            data: env.getJson(), options: option);
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
          TransactionStorage.saveMonthlyVariableData(
              res.data['totalVariable'].abs(),
              resultList,
              env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  static Future<void> getMonthlyFixedIncome(
      envClass env, Function setMonthlyFixedIncome) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getMonthlyFixedIncome',
            data: env.getJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          setMonthlyFixedIncome(
              res.data['disposableIncome'], res.data['monthlyFixedList']);
          TransactionStorage.saveMonthlyFixedIncome(
              res.data['disposableIncome'],
              res.data['monthlyFixedList'],
              env.getJson().toString());
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  static Future<void> getMonthlyFixedSpending(envClass env,
      Function setSnackBar, Function setMonthlyFixedSpending) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getMonthlyFixedSpending',
            data: env.getJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          setMonthlyFixedSpending(
              res.data['disposableIncome'], res.data['monthlyFixedList']);
          TransactionStorage.saveMonthlyFixedSpending(
              res.data['disposableIncome'],
              res.data['monthlyFixedList'],
              env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 取引の追加
  static Future<void> addTransaction(
      TransactionClass transaction,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    if (transactionValidation.checkTransaction(transaction)) {
      setDisable();
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/addTransaction',
            data: transaction.getTransactionJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          TransactionStorage.allDeleteWithParam(
              transaction.userId, transaction.transactionDate);
          if (transaction.subCategoryId == null) {
            CategoryStorage.deleteCategoryWithSubCategoryList();
            CategoryStorage.deleteSubCategoryListWithParam(
                transaction.categoryId.toString());
          }
          backNavigation(isUpdate: false);
        }
      } on DioException catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 取引の編集
  static Future<void> editTransaction(
      TransactionClass transaction,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    setDisable();
    if (transactionValidation.checkTransaction(transaction)) {
      setDisable();
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/editTransaction',
            data: transaction.getTransactionJson(), options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          TransactionStorage.allDeleteWithParam(
              transaction.userId, transaction.transactionDate);
          if (transaction.subCategoryId == null) {
            CategoryStorage.deleteCategoryWithSubCategoryList();
            CategoryStorage.deleteSubCategoryListWithParam(
                transaction.categoryId.toString());
          }
          backNavigation(isUpdate: true);
        }
      } on DioException catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 取引の削除
  static Future<void> deleteTransaction(
      envClass env,
      TransactionClass transaction,
      Function backNavigation,
      Function setDisable,
      Function setSnackBar) async {
    await Api.getHeader().then((option) async {
      try {
        setDisable();
        Response res = await Api.dio.post('$rootURI/deleteTransaction',
            data: {
              'userId': env.userId,
              'transactionId': transaction.transactionId
            },
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
          setDisable();
        } else {
          // 成功
          TransactionStorage.allDeleteWithParam(
              env.userId, transaction.transactionDate);
          backNavigation(isUpdate: true);
        }
      } on DioException catch (e) {
        setDisable();
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// レコメンドリストの取得
  static Future<void> getFrequentTransactionName(
      envClass env, Function setRecommendList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getFrequentTransactionName',
            data: {
              'userId': env.userId,
            },
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['transactionList'].forEach((value) {
            TransactionClass tran = TransactionClass.setFrequentFields(
                value['transactionName'],
                value['categoryId'],
                value['categoryName'],
                value['subCategoryId'],
                value['subCategoryName'],
                value['fixedFlg']);
            resultList.add(tran);
          });
          setRecommendList(resultList);
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// カテゴリ毎の支出総額を取得
  static Future<void> getTotalSpending(
      envClass env,
      TransactionClass transaction,
      Function setTransactionList,
      Function setSnackBar) async {
    if (searchTransactionValidation.checkTransaction(
        transaction, setSnackBar)) {
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/getTotalSpending',
            data: {
              'userId': env.userId,
              'categoryId': transaction.categoryId,
              'subCategoryId': transaction.subCategoryId,
              'startMonth': transaction.startMonth,
              'endMonth': transaction.endMonth,
            },
            options: option);
        if (res.data['status'] == 'error') {
          // 失敗
          setSnackBar(res.data['message']);
        } else {
          // 成功
          List<Map<String, dynamic>> resultList = [];
          res.data['categoryTotalList'].forEach((value) {
            Map<String, dynamic> categoryList = {
              'categoryName': value['categoryName'],
              'categoryTotalAmount': value['categoryTotalAmount'],
              'subCategoryList': value['subCategoryList']
            };
            resultList.add(categoryList);
          });
          setTransactionList(res.data['totalSpending'], resultList);
          if (resultList.isEmpty) {
            setSnackBar('データが存在しませんでした');
          }
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
