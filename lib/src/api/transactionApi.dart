import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/api/validation/searchTransactionValidation.dart';
import 'package:money_hooks/src/api/validation/transactionValidation.dart';
import 'package:money_hooks/src/class/response/monthlyFixedData.dart';
import 'package:money_hooks/src/class/response/monthlyVariableData.dart';
import 'package:money_hooks/src/class/response/withdrawalData.dart';
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
        Response res = await Api.dio.get('$rootURI/getHome',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          setHomeTransaction(res.data['balance'], res.data['category_list']);
          TransactionStorage.saveStorageHomeData(res.data['balance'],
              res.data['category_list'], env.getJson().toString());
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
        Response res = await Api.dio.get('$rootURI/getTimelineData',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['transaction_list'].forEach((value) {
            int transactionId = value['transaction_id'];
            String transactionDate = value['transaction_date'];
            int transactionSign = value['transaction_sign'];
            String transactionAmount = value['transaction_amount'].toString();
            String transactionName = value['transaction_name'];
            int categoryId = value['category_id'];
            String categoryName = value['category_name'];
            int subCategoryId = value['sub_category_id'];
            String subCategoryName = value['sub_category_name'];
            bool fixedFlg = value['fixed_flg'];
            num? paymentId = value['payment_id'];
            String paymentName = value['payment_name'];
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
                fixedFlg,
                paymentId,
                paymentName));
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
        Response res = await Api.dio.get('$rootURI/getMonthlySpendingData',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['monthly_total_amount_list'].reversed.forEach((value) {
            resultList.add(TransactionClass.setTimelineChart(
                value['month'], value['total_amount']));
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
        Response res = await Api.dio.get('$rootURI/getMonthlyVariableData',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          late MonthlyVariableData resultList = MonthlyVariableData();
          resultList.totalVariable = res.data['total_variable'].abs();
          res.data['monthly_variable_list'].forEach((categoryData) {
            List<MVSubCategoryClass> subCategoryList = [];
            categoryData['sub_category_list'].forEach((subCategoryData) {
              List<TransactionClass> tranList = [];
              subCategoryData['transaction_list'].forEach((tranData) {
                tranList.add(TransactionClass.setMonthlyVariableData(tranData));
              });
              subCategoryList
                  .add(MVSubCategoryClass.init(subCategoryData, tranList));
            });
            resultList.monthlyVariableList
                .add(MVCategoryClass.init(categoryData, subCategoryList));
          });

          setMonthlyVariable(
              resultList.totalVariable.abs(), resultList.monthlyVariableList);
          TransactionStorage.saveMonthlyVariableData(
              resultList.totalVariable.abs(),
              resultList.toJson(),
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
        Response res = await Api.dio.get('$rootURI/getMonthlyFixedIncome',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          late MonthlyFixedData resultData = MonthlyFixedData();
          resultData.disposableIncome = res.data['disposable_income'];
          res.data['monthly_fixed_list'].forEach((categoryData) {
            List<TransactionClass> tranList = [];
            categoryData['transaction_list'].forEach((tranData) {
              tranList.add(TransactionClass.setMonthlyFixedData(tranData));
            });
            resultData.monthlyFixedList
                .add(MFCategoryClass.init(categoryData, tranList));
          });

          // 成功
          setMonthlyFixedIncome(
              resultData.disposableIncome, resultData.monthlyFixedList);
          TransactionStorage.saveMonthlyFixedIncome(resultData.disposableIncome,
              resultData.toJson(), env.getJson().toString());
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
        Response res = await Api.dio.get('$rootURI/getMonthlyFixedSpending',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          late MonthlyFixedData resultData = MonthlyFixedData();
          resultData.disposableIncome = res.data['disposable_income'];
          res.data['monthly_fixed_list'].forEach((categoryData) {
            List<TransactionClass> tranList = [];
            categoryData['transaction_list'].forEach((tranData) {
              tranList.add(TransactionClass.setMonthlyFixedData(tranData));
            });
            resultData.monthlyFixedList
                .add(MFCategoryClass.init(categoryData, tranList));
          });

          // 成功
          setMonthlyFixedSpending(
              resultData.disposableIncome, resultData.monthlyFixedList);
          TransactionStorage.saveMonthlyFixedSpending(
              resultData.disposableIncome,
              resultData.toJson(),
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
            data: {'transaction': transaction.getTransactionJson()},
            options: option);
        if (res.statusCode != 200) {
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
        Response res = await Api.dio.patch('$rootURI/editTransaction',
            data: {'transaction': transaction.getTransactionJson()},
            options: option);
        if (res.statusCode != 200) {
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
        Response res = await Api.dio.delete(
            '$rootURI/deleteTransaction/${transaction.transactionId}',
            options: option);
        if (res.statusCode != 200) {
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
        Response res = await Api.dio
            .get('$rootURI/getFrequentTransactionName', options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['transaction_list'].forEach((value) {
            TransactionClass tran = TransactionClass.setFrequentFields(
                value['transaction_name'],
                value['category_id'],
                value['category_name'],
                value['sub_category_id'],
                value['sub_category_name'],
                value['fixed_flg'],
                value['payment_id']);
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
        Response res = await Api.dio.get('$rootURI/getTotalSpending',
            queryParameters: {
              'category_id': transaction.categoryId,
              'sub_category_id': transaction.subCategoryId,
              'start_month': transaction.startMonth,
              'end_month': transaction.endMonth,
            },
            options: option);
        if (res.statusCode != 200) {
          // 失敗
          setSnackBar(res.data['message']);
        } else {
          // 成功
          List<Map<String, dynamic>> resultList = [];
          res.data['category_total_list'].forEach((value) {
            Map<String, dynamic> categoryList = {
              'category_name': value['category_name'],
              'category_total_amount': value['category_total_amount'],
              'sub_category_list': value['sub_category_list']
            };
            resultList.add(categoryList);
          });
          setTransactionList(res.data['total_spending'], resultList);
          if (resultList.isEmpty) {
            setSnackBar('データが存在しませんでした');
          }
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }

  /// 支払い方法毎の支出を取得
  static Future<void> getGroupByPayment(envClass env, Function setLoading,
      Function setSnackBar, Function setPaymentGroupTransaction) async {
    setLoading();

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/groupByPayment',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          setPaymentGroupTransaction(
              res.data['total_spending'],
              res.data['last_month_total_spending'],
              res.data['month_over_month_sum'],
              res.data['payment_list']);
          TransactionStorage.saveGroupByPaymentData(
              res.data['total_spending'],
              res.data['last_month_total_spending'],
              res.data['month_over_month_sum'],
              res.data['payment_list'],
              env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  /// タイムラインカレンダーの引落し予定を取得
  static Future<void> getMonthlyWithdrawalAmount(
      envClass env, Function setSnackBar, Function setWithdrawalList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/getMonthlyWithdrawalAmount',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<WithdrawalData> resultList = [];
          res.data['withdrawal_list'].forEach((value) {
            resultList.add(WithdrawalData.init(
                value['payment_id'],
                value['payment_name'],
                value['payment_date'],
                DateFormat('yyyy-MM-dd').parse(value['aggregation_start_date']),
                DateFormat('yyyy-MM-dd').parse(value['aggregation_end_date']),
                value['withdrawal_amount']));
          });
          setWithdrawalList(resultList);

          TransactionStorage.saveMonthlyWithdrawalAmountData(
              resultList, env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
