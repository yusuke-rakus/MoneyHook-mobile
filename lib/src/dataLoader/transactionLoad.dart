import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/monthlyFixedData.dart';
import 'package:money_hooks/src/class/response/monthlyVariableData.dart';
import 'package:money_hooks/src/common/env/envClass.dart';
import 'package:money_hooks/src/dataLoader/registrationDate.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

class TransactionLoad {
  /// 【タイムライン画面】データ
  static Future<void> getTimelineData(EnvClass env, Function setLoading,
      Function setSnackBar, Function setTimelineData) async {
    await TransactionStorage.getTimelineData(
            env.getJson().toString(), setLoading)
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await TransactionApi.getTimelineData(
            env, setLoading, setSnackBar, setTimelineData);
        await setRegistrationDate();
      } else {
        setTimelineData(value);
      }
    });
  }

  /// 【タイムライン画面】グラフ
  static Future<void> getTimelineChart(
      EnvClass env, Function setTimelineChart) async {
    await TransactionStorage.getTimelineChart(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await TransactionApi.getTimelineChart(env, setTimelineChart);
        await setRegistrationDate();
      } else {
        setTimelineChart(value);
      }
    });
  }

  /// 【ホーム画面】データ
  static Future<void> getHome(EnvClass env, Function setLoading,
      Function setSnackBar, Function setHomeTransaction) async {
    await TransactionStorage.getHome(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await TransactionApi.getHome(
            env, setLoading, setSnackBar, setHomeTransaction);
        await setRegistrationDate();
      } else {
        setHomeTransaction(value['balance'], value['category_list']);
      }
    });
  }

  /// 取引名レコメンド
  static Future<void> getFrequentTransactionName(
      EnvClass env, Function setRecommendList) async {
    await TransactionStorage.getTransactionRecommendState()
        .then((activeState) async {
      if (activeState) {
        await TransactionApi.getFrequentTransactionName(env, setRecommendList);
      }
    });
  }

  /// 【月別変動費画面】データ
  static Future<void> getMonthlyVariableData(EnvClass env, Function setLoading,
      Function setSnackBar, Function setMonthlyVariable) async {
    await TransactionStorage.getMonthlyVariableData(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        await TransactionApi.getMonthlyVariableData(
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
    await TransactionStorage.getMonthlyFixedIncome(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await TransactionApi.getMonthlyFixedIncome(env, setMonthlyFixedIncome);
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
    await TransactionStorage.getMonthlyFixedSpending(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await TransactionApi.getMonthlyFixedSpending(
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

  /// 【支払い方法画面】データ
  static Future<void> getGroupByPayment(EnvClass env, Function setLoading,
      Function setSnackBar, Function setGroupByPaymentTransaction) async {
    await TransactionStorage.getGroupByPayment(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await TransactionApi.getGroupByPayment(
            env, setLoading, setSnackBar, setGroupByPaymentTransaction);
        await setRegistrationDate();
      } else {
        setGroupByPaymentTransaction(
            value['total_spending'],
            value['last_month_total_spending'],
            value['month_over_month_sum'],
            value['payment_list']);
      }
    });
  }

  /// 【タイムライン画面】データ
  static Future<void> getMonthlyWithdrawalAmount(
      EnvClass env, Function setSnackBar, Function setWithdrawalList) async {
    await TransactionStorage.getMonthlyWithdrawalAmount(
            env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await TransactionApi.getMonthlyWithdrawalAmount(
            env, setSnackBar, setWithdrawalList);
        await setRegistrationDate();
      } else {
        setWithdrawalList(value);
      }
    });
  }
}
