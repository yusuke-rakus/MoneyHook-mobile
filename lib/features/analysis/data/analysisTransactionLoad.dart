import 'package:money_hooks/class/response/monthlyFixedData.dart';
import 'package:money_hooks/class/response/monthlyVariableData.dart';
import 'package:money_hooks/common/data/registrationDate.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/analysis/data/analysisTransactionApi.dart';
import 'package:money_hooks/features/analysis/data/analysisTransactionStorage.dart';

class AnalysisTransactionLoad {
  /// 【月別変動費画面】データ
  static Future<void> getMonthlyVariableData(EnvClass env, Function setLoading,
      Function setSnackBar, Function setMonthlyVariable) async {
    await AnalysisTransactionStorage.getMonthlyVariableData(
            env.getJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        await AnalysisTransactionApi.getMonthlyVariableData(
            env, setLoading, setSnackBar, setMonthlyVariable);
      } else {
        setMonthlyVariable(
            value['total_variable'],
            MonthlyVariableData.fromJson(value['monthly_variable_list'])
                .monthlyVariableList);
      }
    });
  }

  /// 【月別固定費画面】収入データ
  static Future<void> getMonthlyFixedIncome(
      EnvClass env, Function setMonthlyFixedIncome) async {
    await AnalysisTransactionStorage.getMonthlyFixedIncome(
            env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await AnalysisTransactionApi.getMonthlyFixedIncome(
            env, setMonthlyFixedIncome);
        await setRegistrationDate();
      } else {
        setMonthlyFixedIncome(
            value['disposable_income'],
            MonthlyFixedData.fromJson(value['monthly_fixed_list'])
                .monthlyFixedList);
      }
    });
  }

  /// 【月別固定費画面】支出データ
  static Future<void> getMonthlyFixedSpending(EnvClass env,
      Function setSnackBar, Function setMonthlyFixedSpending) async {
    await AnalysisTransactionStorage.getMonthlyFixedSpending(
            env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await AnalysisTransactionApi.getMonthlyFixedSpending(
            env, setSnackBar, setMonthlyFixedSpending);
        await setRegistrationDate();
      } else {
        setMonthlyFixedSpending(
            value['disposable_income'],
            MonthlyFixedData.fromJson(value['monthly_fixed_list'])
                .monthlyFixedList);
      }
    });
  }
}
