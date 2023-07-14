import 'package:dio/dio.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

import '../api/api.dart';
import '../env/envClass.dart';

class transactionLoad {
  static String rootURI = '${Api.rootURI}/transaction';
  static Dio dio = Dio();

  /// 【タイムライン画面】データ
  static Future<void> getTimelineData(
      envClass env, Function setLoading, Function setTimelineData) async {
    transactionStorage
        .searchTimelineData(env.getJson().toString(), setLoading)
        .then((value) async {
      if (value.isEmpty) {
        transactionApi.getTimelineData(env, setLoading, setTimelineData);
      } else {
        setTimelineData(value);
      }
    });
  }

  /// 【タイムライン画面】グラフ
  static Future<void> getTimelineChart(
      envClass env, Function setTimelineChart) async {
    transactionStorage
        .getTimelineChart(env.getJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        transactionApi.getTimelineChart(env, setTimelineChart);
      } else {
        setTimelineChart(value);
      }
    });
  }

  /// 【ホーム画面】データ
  static Future<void> getHome(
      envClass env, Function setLoading, Function setHomeTransaction) async {
    transactionStorage.getHome(env.getJson().toString()).then((value) {
      if (value.isEmpty) {
        transactionApi.getHome(env, setLoading, setHomeTransaction);
      } else {
        setHomeTransaction(value['balance'], value['categoryList']);
      }
    });
  }

  /// 取引名レコメンド
  static void getFrequentTransactionName(
      envClass env, Function setRecommendList) async {
    transactionStorage.getTransactionRecommendState().then((activeState) {
      if (activeState) {
        transactionApi.getFrequentTransactionName(env, setRecommendList);
      }
    });
  }

  /// 【月別変動費画面】データ
  static void getMonthlyVariableData(
      envClass env, Function setLoading, Function setMonthlyVariable) async {
    transactionStorage
        .getMonthlyVariableData(env.getJson().toString())
        .then((value) {
      if (value.isEmpty) {
        transactionApi.getMonthlyVariableData(
            env, setLoading, setMonthlyVariable);
      } else {
        setMonthlyVariable(
            value['totalVariable'], value['monthlyVariableList']);
      }
    });
  }

  /// 【月別固定費画面】収入データ
  static void getMonthlyFixedIncome(
      envClass env, Function setMonthlyFixedIncome) async {
    transactionStorage
        .getMonthlyFixedIncome(env.getJson().toString())
        .then((value) {
      if (value.isEmpty) {
        transactionApi.getMonthlyFixedIncome(env, setMonthlyFixedIncome);
      } else {
        setMonthlyFixedIncome(
            value['disposableIncome'], value['monthlyFixedList']);
      }
    });
  }

  /// 【月別固定費画面】支出データ
  static void getMonthlyFixedSpending(envClass env, Function setLoading,
      Function setMonthlyFixedSpending) async {
    transactionStorage
        .getMonthlyFixedSpending(env.getJson().toString())
        .then((value) {
      if (value.isEmpty) {
        transactionApi.getMonthlyFixedSpending(
            env, setLoading, setMonthlyFixedSpending);
      } else {
        setMonthlyFixedSpending(
            value['disposableIncome'], value['monthlyFixedList']);
      }
    });
  }
}
