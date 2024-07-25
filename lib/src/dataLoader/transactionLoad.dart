import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/dataLoader/registrationDate.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

class TransactionLoad {
  /// 【タイムライン画面】データ
  static Future<void> getTimelineData(envClass env, Function setLoading,
      Function setSnackBar, Function setTimelineData) async {
    await TransactionStorage.getTimelineData(
            env.getJson().toString(), setLoading)
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await transactionApi.getTimelineData(
            env, setLoading, setSnackBar, setTimelineData);
        await setRegistrationDate();
      } else {
        setTimelineData(value);
      }
    });
  }

  /// 【タイムライン画面】グラフ
  static Future<void> getTimelineChart(
      envClass env, Function setTimelineChart) async {
    await TransactionStorage.getTimelineChart(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await transactionApi.getTimelineChart(env, setTimelineChart);
        await setRegistrationDate();
      } else {
        setTimelineChart(value);
      }
    });
  }

  /// 【ホーム画面】データ
  static Future<void> getHome(envClass env, Function setLoading,
      Function setSnackBar, Function setHomeTransaction) async {
    await TransactionStorage.getHome(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await transactionApi.getHome(
            env, setLoading, setSnackBar, setHomeTransaction);
        await setRegistrationDate();
      } else {
        setHomeTransaction(value['balance'], value['category_list']);
      }
    });
  }

  /// 取引名レコメンド
  static Future<void> getFrequentTransactionName(
      envClass env, Function setRecommendList) async {
    await TransactionStorage.getTransactionRecommendState()
        .then((activeState) async {
      if (activeState) {
        await transactionApi.getFrequentTransactionName(env, setRecommendList);
      }
    });
  }

  /// 【月別変動費画面】データ
  static Future<void> getMonthlyVariableData(envClass env, Function setLoading,
      Function setSnackBar, Function setMonthlyVariable) async {
    await TransactionStorage.getMonthlyVariableData(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        await transactionApi.getMonthlyVariableData(
            env, setLoading, setSnackBar, setMonthlyVariable);
      } else {
        setMonthlyVariable(
            value['total_variable'], value['monthly_variable_list']);
      }
    });
  }

  /// 【月別固定費画面】収入データ
  static Future<void> getMonthlyFixedIncome(
      envClass env, Function setMonthlyFixedIncome) async {
    await TransactionStorage.getMonthlyFixedIncome(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await transactionApi.getMonthlyFixedIncome(env, setMonthlyFixedIncome);
        await setRegistrationDate();
      } else {
        setMonthlyFixedIncome(
            value['disposable_income'], value['monthly_fixed_list']);
      }
    });
  }

  /// 【月別固定費画面】支出データ
  static Future<void> getMonthlyFixedSpending(envClass env,
      Function setSnackBar, Function setMonthlyFixedSpending) async {
    await TransactionStorage.getMonthlyFixedSpending(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await transactionApi.getMonthlyFixedSpending(
            env, setSnackBar, setMonthlyFixedSpending);
        await setRegistrationDate();
      } else {
        setMonthlyFixedSpending(
            value['disposable_income'], value['monthly_fixed_list']);
      }
    });
  }

  /// 【支払い方法画面】データ
  static Future<void> getGroupByPayment(envClass env, Function setLoading,
      Function setSnackBar, Function setGroupByPaymentTransaction) async {
    await TransactionStorage.getGroupByPayment(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await transactionApi.getGroupByPayment(
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
      envClass env, Function setSnackBar, Function setWithdrawalList) async {
    await TransactionStorage.getMonthlyWithdrawalAmount(
            env.getJson().toString())
        .then((value) async {
      if (value.isEmpty || await isNeedApi()) {
        await transactionApi.getMonthlyWithdrawalAmount(
            env, setSnackBar, setWithdrawalList);
        await setRegistrationDate();
      } else {
        setWithdrawalList(value);
      }
    });
  }
}
