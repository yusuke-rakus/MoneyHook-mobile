import 'package:intl/intl.dart';
import 'package:localstore/localstore.dart';
import 'package:money_hooks/features/timeline/class/withdrawalData.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/env/envClass.dart';

class TimelineTransactionStorage {
  static final db = Localstore.instance;

  /// 【タイムライン画面】データ
  static Future<List<TransactionClass>> getTimelineData(
      String param, Function setLoading) async {
    setLoading();

    final id = 'timeline_data$param';
    List<TransactionClass> resultList = [];

    await db.collection('timeline_data').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          String transactionId = e['transaction_id'];
          String transactionDate = e['transaction_date'];
          int transactionSign = e['transaction_sign'];
          String transactionAmount = e['transaction_amount'].toString();
          String transactionName = e['transaction_name'];
          String categoryId = e['category_id'];
          String categoryName = e['category_name'];
          String subCategoryId = e['sub_category_id'];
          String subCategoryName = e['sub_category_name'];
          String? paymentId = e['payment_id'];
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
    EnvClass env = EnvClass.initNew(userId, transactionDate);
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
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'timeline_chart${env.getJson()}';
    await db.collection('timeline_chart').doc(id).delete();
  }

  /// 【タイムライン画面】データ
  static Future<List<WithdrawalData>> getMonthlyWithdrawalAmount(
      String param) async {
    final id = 'withdrawal_amount$param';
    List<WithdrawalData> resultList = [];

    await db.collection('withdrawal_amount_data').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          String paymentId = e['payment_id'];
          String paymentName = e['payment_name'];
          int paymentDate = e['payment_date'];
          DateTime aggregationStartDate =
              DateFormat('yyyy-MM-dd').parse(e['aggregation_start_date']);
          DateTime aggregationEndDate =
              DateFormat('yyyy-MM-dd').parse(e['aggregation_end_date']);
          int withdrawalAmount = e['withdrawal_amount'];
          resultList.add(WithdrawalData.init(
              paymentId,
              paymentName,
              paymentDate,
              aggregationStartDate,
              aggregationEndDate,
              withdrawalAmount));
        });
      }
    });
    return resultList;
  }

  static void saveMonthlyWithdrawalAmountData(
      List<WithdrawalData> resultList, String param) async {
    await db
        .collection('withdrawal_amount_data')
        .doc('withdrawal_amount$param')
        .set({'data': resultList.map((e) => e.getWithdrawalJson()).toList()});
  }

  static void deleteMonthlyWithdrawalAmountData() async {
    await db.collection('withdrawal_amount_data').delete();
  }

  static void deleteMonthlyWithdrawalAmountDataWithParam(
      String userId, String transactionDate) async {
    EnvClass env = EnvClass.initNew(userId, transactionDate);
    final id = 'withdrawal_amount${env.getJson()}';
    await db.collection('withdrawal_amount_data').doc(id).delete();
  }
}
