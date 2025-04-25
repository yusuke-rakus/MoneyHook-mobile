import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/data/registrationDate.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/timeline/class/withdrawalData.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionApi.dart';
import 'package:money_hooks/features/timeline/data/timelineTransactionStorage.dart';

class TimelineTransactionLoad {
  /// 【タイムライン画面】データ
  static Future<void> getTimelineData(EnvClass env, Function setLoading,
      Function setSnackBar, Function setTimelineData) async {
    List<TransactionClass> value =
        await TimelineTransactionStorage.getTimelineData(
            env.getJson().toString(), setLoading);

    if (value.isEmpty || await isNeedApi()) {
      await TimelineTransactionApi.getTimelineData(
          env, setLoading, setSnackBar, setTimelineData);
      await setRegistrationDate();
    } else {
      setTimelineData(value);
    }
  }

  /// 【タイムライン画面】グラフ
  static Future<void> getTimelineChart(
      EnvClass env, Function setTimelineChart) async {
    List<TransactionClass> value =
        await TimelineTransactionStorage.getTimelineChart(
            env.getJson().toString());

    if (value.isEmpty || await isNeedApi()) {
      await TimelineTransactionApi.getTimelineChart(env, setTimelineChart);
      await setRegistrationDate();
    } else {
      setTimelineChart(value);
    }
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
