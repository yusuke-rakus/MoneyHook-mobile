import 'package:localstore/localstore.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/transactionClass.dart';

class TransactionStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    deleteTimelineData();
    deleteTimelineChart();
    deleteHomeData();
    deleteMonthlyVariableData();
    deleteMonthlyFixedIncome();
    deleteMonthlyFixedSpending();
  }

  /// ストレージ全削除(月指定)
  static void allDeleteWithParam(String userId, String transactionDate) {
    deleteTimelineDataWithParam(userId, transactionDate);
    deleteTimelineChartWithParam(userId, transactionDate);
    deleteHomeDataWithParam(userId, transactionDate);
    deleteMonthlyVariableDataWithParam(userId, transactionDate);
    deleteMonthlyFixedIncomeWithParam(userId, transactionDate);
    deleteMonthlyFixedSpendingWithParam(userId, transactionDate);
  }

  /// 【タイムライン画面】データ
  static Future<List<transactionClass>> getTimelineData(
      String param, Function setLoading) async {
    setLoading();

    final id = 'timelineData$param';
    List<transactionClass> resultList = [];

    await db.collection('timelineData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          String transactionId = e['transactionId'].toString();
          String transactionDate = e['transactionDate'];
          int transactionSign = e['transactionSign'];
          String transactionAmount = e['transactionAmount'].toString();
          String transactionName = e['transactionName'];
          String categoryName = e['categoryName'];
          String subCategoryName = e['subCategoryName'];
          bool fixedFlg = e['fixedFlg'];
          resultList.add(transactionClass.setTimelineFields(
              transactionId,
              transactionDate,
              transactionSign,
              int.parse(transactionAmount),
              transactionName,
              categoryName,
              subCategoryName,
              fixedFlg));
        });
      }
    }).then((value) => setLoading());
    return resultList;
  }

  static void saveStorageTimelineData(
      List<transactionClass> resultList, String param) async {
    await db
        .collection('timelineData')
        .doc('timelineData$param')
        .set({'data': resultList.map((e) => e.getTransactionJson()).toList()});
  }

  static void deleteTimelineData() async {
    await db.collection('timelineData').delete();
  }

  static void deleteTimelineDataWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'timelineData${env.getJson()}';
    await db.collection('timelineData').doc(id).delete();
  }

  /// 【タイムライン画面】グラフ
  static Future<List<transactionClass>> getTimelineChart(String param) async {
    final id = 'timelineChart$param';
    List<transactionClass> resultList = [];

    await db.collection('timelineChart').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(transactionClass.setTimelineChart(
              e['transactionDate'], e['transactionAmount']));
        });
      }
    });
    return resultList;
  }

  static void saveStorageTimelineChart(
      List<transactionClass> resultList, String param) async {
    await db
        .collection('timelineChart')
        .doc('timelineChart$param')
        .set({'data': resultList.map((e) => e.getTransactionJson()).toList()});
  }

  static void deleteTimelineChart() async {
    await db.collection('timelineChart').delete();
  }

  static void deleteTimelineChartWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'timelineChart${env.getJson()}';
    await db.collection('timelineChart').doc(id).delete();
  }

  /// 【ホーム画面】データ
  static Future<Map<String, dynamic>> getHome(String param) async {
    final id = 'homeData$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('homeData').doc(id).get().then((value) {
      if (value != null) {
        resultMap['balance'] = value['balance'];
        resultMap['categoryList'] = value['categoryList'];
      }
    });
    return resultMap;
  }

  static void saveStorageHomeData(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('homeData')
        .doc('homeData$param')
        .set({'balance': balance, 'categoryList': resultList});
  }

  static void deleteHomeData() async {
    await db.collection('homeData').delete();
  }

  static void deleteHomeDataWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'homeData${env.getJson()}';
    await db.collection('homeData').doc(id).delete();
  }

  /// 取引名レコメンド
  static Future<bool> getTransactionRecommendState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? activeState = prefs.getBool('IS_TRANSACTION_RECOMMEND_ACTIVE');
    if (activeState == null) {
      await prefs.setBool('IS_TRANSACTION_RECOMMEND_ACTIVE', true);
      return true;
    } else {
      return activeState;
    }
  }

  /// 取引名レコメンド
  static void setTransactionRecommendState(bool activeState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_TRANSACTION_RECOMMEND_ACTIVE', activeState);
  }

  /// 【月別変動費画面】データ
  static Future<Map<String, dynamic>> getMonthlyVariableData(
      String param) async {
    final id = 'monthlyVariableData$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('monthlyVariableData').doc(id).get().then((value) {
      if (value != null) {
        resultMap['totalVariable'] = value['totalVariable'];
        resultMap['monthlyVariableList'] = value['monthlyVariableList'];
      }
    });
    return resultMap;
  }

  static void saveMonthlyVariableData(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('monthlyVariableData')
        .doc('monthlyVariableData$param')
        .set({'totalVariable': balance, 'monthlyVariableList': resultList});
  }

  static void deleteMonthlyVariableData() async {
    await db.collection('monthlyVariableData').delete();
  }

  static void deleteMonthlyVariableDataWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'monthlyVariableData${env.getJson()}';
    await db.collection('monthlyVariableData').doc(id).delete();
  }

  /// 【月別固定費画面】収入データ
  static Future<Map<String, dynamic>> getMonthlyFixedIncome(
      String param) async {
    final id = 'monthlyFixedIncomeData$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('monthlyFixedIncomeData').doc(id).get().then((value) {
      if (value != null) {
        resultMap['disposableIncome'] = value['disposableIncome'];
        resultMap['monthlyFixedList'] = value['monthlyFixedList'];
      }
    });
    return resultMap;
  }

  static void saveMonthlyFixedIncome(
      int disposableIncome, List<dynamic> resultList, String param) async {
    await db
        .collection('monthlyFixedIncomeData')
        .doc('monthlyFixedIncomeData$param')
        .set({
      'disposableIncome': disposableIncome,
      'monthlyFixedList': resultList
    });
  }

  static void deleteMonthlyFixedIncome() async {
    await db.collection('monthlyFixedIncomeData').delete();
  }

  static void deleteMonthlyFixedIncomeWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'monthlyFixedIncomeData${env.getJson()}';
    await db.collection('monthlyFixedIncomeData').doc(id).delete();
  }

  /// 【月別固定費画面】支出データ
  static Future<Map<String, dynamic>> getMonthlyFixedSpending(
      String param) async {
    final id = 'monthlyFixedSpendingData$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('monthlyFixedSpendingData').doc(id).get().then((value) {
      if (value != null) {
        resultMap['disposableIncome'] = value['disposableIncome'];
        resultMap['monthlyFixedList'] = value['monthlyFixedList'];
      }
    });
    return resultMap;
  }

  static void saveMonthlyFixedSpending(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('monthlyFixedSpendingData')
        .doc('monthlyFixedSpendingData$param')
        .set({'disposableIncome': balance, 'monthlyFixedList': resultList});
  }

  static void deleteMonthlyFixedSpending() async {
    await db.collection('monthlyFixedSpendingData').delete();
  }

  static void deleteMonthlyFixedSpendingWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'monthlyFixedSpendingData${env.getJson()}';
    await db.collection('monthlyFixedSpendingData').doc(id).delete();
  }
}
