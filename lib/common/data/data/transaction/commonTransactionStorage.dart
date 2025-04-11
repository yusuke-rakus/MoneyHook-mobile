import 'package:localstore/localstore.dart';
import 'package:money_hooks/features/analysis/data/analysisTransactionStorage.dart';
import 'package:money_hooks/features/home/data/homeTransactionStorage.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionStorage.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonTranTransactionStorage {
  static final db = Localstore.instance;

  /// ストレージ全削除
  static void allDelete() {
    TimelineTransactionStorage.deleteTimelineData();
    TimelineTransactionStorage.deleteTimelineChart();
    HomeTransactionStorage.deleteHomeData();
    AnalysisTransactionStorage.deleteMonthlyVariableData();
    AnalysisTransactionStorage.deleteMonthlyFixedIncome();
    AnalysisTransactionStorage.deleteMonthlyFixedSpending();
    PaymentGroupTransactionStorage.deleteGroupByPaymentData();
    TimelineTransactionStorage.deleteMonthlyWithdrawalAmountData();
  }

  /// ストレージ全削除(月指定)
  static void allDeleteWithParam(String userId, String transactionDate) {
    TimelineTransactionStorage.deleteTimelineDataWithParam(
        userId, transactionDate);
    TimelineTransactionStorage.deleteTimelineChartWithParam(
        userId, transactionDate);
    HomeTransactionStorage.deleteHomeDataWithParam(userId, transactionDate);
    AnalysisTransactionStorage.deleteMonthlyVariableDataWithParam(
        userId, transactionDate);
    AnalysisTransactionStorage.deleteMonthlyFixedIncomeWithParam(
        userId, transactionDate);
    AnalysisTransactionStorage.deleteMonthlyFixedSpendingWithParam(
        userId, transactionDate);
    PaymentGroupTransactionStorage.deleteGroupByPaymentDataWithParam(
        userId, transactionDate);
    TimelineTransactionStorage.deleteMonthlyWithdrawalAmountDataWithParam(
        userId, transactionDate);
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

  /// デフォルトでカードを開けた他状態にするかどうか
  static Future<bool> getIsCardDefaultOpenState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? activeState = prefs.getBool('IS_CARD_DEFAULT_OPEN');
    if (activeState == null) {
      await prefs.setBool('IS_CARD_DEFAULT_OPEN', true);
      return true;
    } else {
      return activeState;
    }
  }
}
