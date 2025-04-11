import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/class/response/withdrawalData.dart';
import 'package:money_hooks/class/transactionClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionStorage.dart';

class TimelineTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  static Future<void> getTimelineData(EnvClass env, Function setLoading,
      Function setSnackBar, Function setTimelineData) async {
    setLoading();

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/getTimelineData',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['transaction_list'].forEach((value) {
            String transactionId = value['transaction_id'];
            String transactionDate = value['transaction_date'];
            int transactionSign = value['transaction_sign'];
            String transactionAmount = value['transaction_amount'].toString();
            String transactionName = value['transaction_name'];
            String categoryId = value['category_id'];
            String categoryName = value['category_name'];
            String subCategoryId = value['sub_category_id'];
            String subCategoryName = value['sub_category_name'];
            bool fixedFlg = value['fixed_flg'];
            String? paymentId = value['payment_id'];
            String? paymentName = value['payment_name'];
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
          setTimelineData(resultList);
          TimelineTransactionStorage.saveStorageTimelineData(
              resultList, env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      } finally {
        setLoading();
      }
    });
  }

  static Future<void> getTimelineChart(
      EnvClass env, Function setTimelineChart) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/getMonthlySpendingData',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['monthly_total_amount_list'].reversed.forEach((value) {
            resultList.add(TransactionClass.setTimelineChart(
                value['month'], value['total_amount']));
          });
          setTimelineChart(resultList);
          TimelineTransactionStorage.saveStorageTimelineChart(
              resultList, env.getJson().toString());
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// タイムラインカレンダーの引落し予定を取得
  static Future<void> getMonthlyWithdrawalAmount(
      EnvClass env, Function setSnackBar, Function setWithdrawalList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/getMonthlyWithdrawalAmount',
            queryParameters: env.getJson(), options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<WithdrawalData> resultList = [];
          res.data['withdrawal_list'].forEach((value) {
            resultList.add(WithdrawalData.init(
                value['payment_id'],
                value['payment_name'],
                value['payment_date'],
                DateFormat('yyyy-MM-dd').parse(value['aggregation_start_date']),
                DateFormat('yyyy-MM-dd').parse(value['aggregation_end_date']),
                value['withdrawal_amount']));
          });
          setWithdrawalList(resultList);

          TimelineTransactionStorage.saveMonthlyWithdrawalAmountData(
              resultList, env.getJson().toString());
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
