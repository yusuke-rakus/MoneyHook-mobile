import 'package:localstore/localstore.dart';
import 'package:money_hooks/common/env/envClass.dart';

class AnalysisTransactionStorage {
  static final db = Localstore.instance;

  /// 【月別変動費画面】データ
  static Future<Map<String, dynamic>> getMonthlyVariableData(
      String param) async {
    final id = 'monthly_variable_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    Map<String, dynamic>? value =
        await db.collection('monthly_variable_data').doc(id).get();
    if (value != null) {
      resultMap['total_variable'] = value['total_variable'];
      resultMap['monthly_variable_list'] = value['monthly_variable_list'];
    }

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
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'monthly_variable_data${env.getJson()}';
    await db.collection('monthly_variable_data').doc(id).delete();
  }

  /// 【月別固定費画面】収入データ
  static Future<Map<String, dynamic>> getMonthlyFixedIncome(
      String param) async {
    final id = 'monthly_fixed_income_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    Map<String, dynamic>? value =
        await db.collection('monthly_fixed_income_data').doc(id).get();

    if (value != null) {
      resultMap['disposable_income'] = value['disposable_income'];
      resultMap['monthly_fixed_list'] = value['monthly_fixed_list'];
    }

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
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'monthly_fixed_income_data${env.getJson()}';
    await db.collection('monthly_fixed_income_data').doc(id).delete();
  }

  /// 【月別固定費画面】支出データ
  static Future<Map<String, dynamic>> getMonthlyFixedSpending(
      String param) async {
    final id = 'monthly_fixed_spending_data$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    Map<String, dynamic>? value =
        await db.collection('monthly_fixed_spending_data').doc(id).get();

    if (value != null) {
      resultMap['disposable_income'] = value['disposable_income'];
      resultMap['monthly_fixed_list'] = value['monthly_fixed_list'];
    }

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
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'monthly_fixed_spending_data${env.getJson()}';
    await db.collection('monthly_fixed_spending_data').doc(id).delete();
  }
}
