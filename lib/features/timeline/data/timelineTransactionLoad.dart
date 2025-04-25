import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/data/registrationDate.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/timeline/class/withdrawalData.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionApi.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionStorage.dart';

class TimelineTransactionLoad {
  /// 【タイムライン画面】データ
  static Future<List<TransactionClass>> getTimelineData(
      EnvClass env, Function setLoading, Function setSnackBar) async {
    List<TransactionClass> transactions = [];

    List<TransactionClass> value =
        await TimelineTransactionStorage.getTimelineData(
            env.getJson().toString(), setLoading);

    if (value.isEmpty || await isNeedApi()) {
      transactions = await TimelineTransactionApi.getTimelineData(
          env, setLoading, setSnackBar);
      await setRegistrationDate();
    } else {
      transactions = value;
    }
    return transactions;
  }

  /// 【タイムライン画面】グラフ
  static Future<List<TransactionClass>> getTimelineChart(EnvClass env) async {
    List<TransactionClass> transactions = [];

    List<TransactionClass> value =
        await TimelineTransactionStorage.getTimelineChart(
            env.getJson().toString());

    if (value.isEmpty || await isNeedApi()) {
      transactions = await TimelineTransactionApi.getTimelineChart(env);
      await setRegistrationDate();
    } else {
      transactions = value;
    }
    return transactions;
  }

  /// 【タイムライン画面】データ
  static Future<void> getMonthlyWithdrawalAmount(
      EnvClass env, Function setSnackBar, Function setWithdrawalList) async {
    List<WithdrawalData> value =
        await TimelineTransactionStorage.getMonthlyWithdrawalAmount(
            env.getJson().toString());

    if (value.isEmpty || await isNeedApi()) {
      await TimelineTransactionApi.getMonthlyWithdrawalAmount(
          env, setSnackBar, setWithdrawalList);
      await setRegistrationDate();
    } else {
      setWithdrawalList(value);
    }
  }
}
