import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

import '../env/envClass.dart';

class TransactionLoad {
  /// 【タイムライン画面】データ
  static Future<void> getTimelineData(envClass env, Function setLoading,
      Function setSnackBar, Function setTimelineData) async {
    await TransactionStorage.getTimelineData(
            env.getJson().toString(), setLoading)
        .then((value) async {
      if (value.isEmpty) {
        await transactionApi.getTimelineData(
            env, setLoading, setSnackBar, setTimelineData);
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
      if (value.isEmpty) {
        await transactionApi.getTimelineChart(env, setTimelineChart);
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
      if (value.isEmpty) {
        await transactionApi.getHome(
            env, setLoading, setSnackBar, setHomeTransaction);
      } else {
        setHomeTransaction(value['balance'], value['categoryList']);
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
            value['totalVariable'], value['monthlyVariableList']);
      }
    });
  }

  /// 【月別固定費画面】収入データ
  static Future<void> getMonthlyFixedIncome(
      envClass env, Function setMonthlyFixedIncome) async {
    await TransactionStorage.getMonthlyFixedIncome(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        await transactionApi.getMonthlyFixedIncome(env, setMonthlyFixedIncome);
      } else {
        setMonthlyFixedIncome(
            value['disposableIncome'], value['monthlyFixedList']);
      }
    });
  }

  /// 【月別固定費画面】支出データ
  static Future<void> getMonthlyFixedSpending(envClass env, Function setLoading,
      Function setSnackBar, Function setMonthlyFixedSpending) async {
    await TransactionStorage.getMonthlyFixedSpending(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        await transactionApi.getMonthlyFixedSpending(
            env, setLoading, setSnackBar, setMonthlyFixedSpending);
      } else {
        setMonthlyFixedSpending(
            value['disposableIncome'], value['monthlyFixedList']);
      }
    });
  }
}
