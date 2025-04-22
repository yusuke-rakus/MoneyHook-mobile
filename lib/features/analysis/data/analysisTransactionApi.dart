import 'package:dio/dio.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/analysis/class/monthlyFixedData.dart';
import 'package:money_hooks/features/analysis/class/monthlyVariableData.dart';
import 'package:money_hooks/features/analysis/data/analysisTransactionStorage.dart';

class AnalysisTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  static Future<void> getMonthlyVariableData(EnvClass env, Function setLoading,
      setSnackBar, Function setMonthlyVariable) async {
    setLoading();
    Options? option = await Api.getHeader();
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
        AnalysisTransactionStorage.saveMonthlyVariableData(
            resultList.totalVariable.abs(),
            resultList.toJson(),
            env.getJson().toString());
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
    } finally {
      setLoading();
    }
  }

  static Future<void> getMonthlyFixedIncome(
      EnvClass env, Function setMonthlyFixedIncome) async {
    Options? option = await Api.getHeader();
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
        AnalysisTransactionStorage.saveMonthlyFixedIncome(
            resultData.disposableIncome,
            resultData.toJson(),
            env.getJson().toString());
      }
    } on DioException catch (e) {
      Api.errorMessage(e);
    }
  }

  static Future<void> getMonthlyFixedSpending(EnvClass env,
      Function setSnackBar, Function setMonthlyFixedSpending) async {
    Options? option = await Api.getHeader();
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
        AnalysisTransactionStorage.saveMonthlyFixedSpending(
            resultData.disposableIncome,
            resultData.toJson(),
            env.getJson().toString());
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
    }
  }
}
