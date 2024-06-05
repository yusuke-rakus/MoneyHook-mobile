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
  static Future<List<TransactionClass>> getTimelineData(
      String param, Function setLoading) async {
    setLoading();

    final id = 'timeline_data$param';
    List<TransactionClass> resultList = [];

    await db.collection('timeline_data').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          int transactionId = e['transaction_id'];
          String transactionDate = e['transaction_date'];
          int transactionSign = e['transaction_sign'];
          String transactionAmount = e['transaction_amount'].toString();
          String transactionName = e['transaction_name'];
          int categoryId = e['category_id'];
          String categoryName = e['category_name'];
          int subCategoryId = e['sub_category_id'];
          String subCategoryName = e['sub_category_name'];
          num? paymentId = e['payment_id'];
          String paymentName = e['payment_name'];
          bool fixedFlg = e['fixed_flg'];
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
      }
    }).then((value) => setLoading());
    return resultList;
  }

  static void saveStorageTimelineData(
      List<TransactionClass> resultList, String param) async {
    await db
        .collection('timeline_data')
        .doc('timeline_data$param')
        .set({'data': resultList.map((e) => e.getTransactionJson()).toList()});
  }

  static void deleteTimelineData() async {
    await db.collection('timeline_data').delete();
  }

  static void deleteTimelineDataWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'timeline_data${env.getJson()}';
    await db.collection('timeline_data').doc(id).delete();
  }

  /// 【タイムライン画面】グラフ
  static Future<List<TransactionClass>> getTimelineChart(String param) async {
    final id = 'timeline_chart$param';
    List<TransactionClass> resultList = [];

    await db.collection('timeline_chart').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(TransactionClass.setTimelineChart(
              e['transaction_date'], e['transaction_amount']));
        });
      }
    });
    return resultList;
  }

  static void saveStorageTimelineChart(
      List<TransactionClass> resultList, String param) async {
    await db
        .collection('timeline_chart')
        .doc('timeline_chart$param')
        .set({'data': resultList.map((e) => e.getTransactionJson()).toList()});
  }

  static void deleteTimelineChart() async {
    await db.collection('timeline_chart').delete();
  }

  static void deleteTimelineChartWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'timeline_chart${env.getJson()}';
    await db.collection('timeline_chart').doc(id).delete();
  }

  /// 【ホーム画面】データ
  static Future<Map<String, dynamic>> getHome(String param) async {
    final id = 'home_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('home_data').doc(id).get().then((value) {
      if (value != null) {
        resultMap['balance'] = value['balance'];
        resultMap['category_list'] = value['category_list'];
      }
    });
    return resultMap;
  }

  static void saveStorageHomeData(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('home_data')
        .doc('home_data$param')
        .set({'balance': balance, 'category_list': resultList});
  }

  static void deleteHomeData() async {
    await db.collection('home_data').delete();
  }

  static void deleteHomeDataWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'home_data${env.getJson()}';
    await db.collection('home_data').doc(id).delete();
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
    final id = 'monthly_variable_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('monthly_variable_data').doc(id).get().then((value) {
      if (value != null) {
        resultMap['total_variable'] = value['total_variable'];
        resultMap['monthly_variable_list'] = value['monthly_variable_list'];
      }
    });
    return resultMap;
  }

  static void saveMonthlyVariableData(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('monthly_variable_data')
        .doc('monthly_variable_data$param')
        .set({'total_variable': balance, 'monthly_variable_list': resultList});
  }

  static void deleteMonthlyVariableData() async {
    await db.collection('monthly_variable_data').delete();
  }

  static void deleteMonthlyVariableDataWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'monthly_variable_data${env.getJson()}';
    await db.collection('monthly_variable_data').doc(id).delete();
  }

  /// 【月別固定費画面】収入データ
  static Future<Map<String, dynamic>> getMonthlyFixedIncome(
      String param) async {
    final id = 'monthly_fixed_income_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db
        .collection('monthly_fixed_income_data')
        .doc(id)
        .get()
        .then((value) {
      if (value != null) {
        resultMap['disposable_income'] = value['disposable_income'];
        resultMap['monthly_fixed_list'] = value['monthly_fixed_list'];
      }
    });
    return resultMap;
  }

  static void saveMonthlyFixedIncome(
      int disposableIncome, List<dynamic> resultList, String param) async {
    await db
        .collection('monthly_fixed_income_data')
        .doc('monthly_fixed_income_data$param')
        .set({
      'disposable_income': disposableIncome,
      'monthly_fixed_list': resultList
    });
  }

  static void deleteMonthlyFixedIncome() async {
    await db.collection('monthly_fixed_income_data').delete();
  }

  static void deleteMonthlyFixedIncomeWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'monthly_fixed_income_data${env.getJson()}';
    await db.collection('monthly_fixed_income_data').doc(id).delete();
  }

  /// 【月別固定費画面】支出データ
  static Future<Map<String, dynamic>> getMonthlyFixedSpending(
      String param) async {
    final id = 'monthly_fixed_spending_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db
        .collection('monthly_fixed_spending_data')
        .doc(id)
        .get()
        .then((value) {
      if (value != null) {
        resultMap['disposable_income'] = value['disposable_income'];
        resultMap['monthly_fixed_list'] = value['monthly_fixed_list'];
      }
    });
    return resultMap;
  }

  static void saveMonthlyFixedSpending(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('monthly_fixed_spending_data')
        .doc('monthly_fixed_spending_data$param')
        .set({'disposable_income': balance, 'monthly_fixed_list': resultList});
  }

  static void deleteMonthlyFixedSpending() async {
    await db.collection('monthly_fixed_spending_data').delete();
  }

  static void deleteMonthlyFixedSpendingWithParam(
      String userId, String transactionDate) async {
    envClass env = envClass.initNew(userId, transactionDate);
    final id = 'monthlyFixedSpendingData${env.getJson()}';
    await db.collection('monthly_fixed_spending_data').doc(id).delete();
  }
}
