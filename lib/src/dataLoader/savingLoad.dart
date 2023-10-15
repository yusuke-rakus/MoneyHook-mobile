import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/searchStorage/savingStorage.dart';

import '../env/envClass.dart';

class SavingLoad {
  /// 【貯金一覧画面】データ
  static Future<void> getMonthlySavingData(envClass env, Function setLoading,
      Function setSnackBar, Function setSavingList) async {
    await SavingStorage.getMonthlySavingData(
            env.getJson().toString(), setLoading)
        .then((value) async {
      if (value.isEmpty) {
        await SavingApi.getMonthlySavingData(
            env, setLoading, setSnackBar, setSavingList);
      } else {
        num resultAmount = 0;
        for (var e in value) {
          resultAmount += e.savingAmount;
        }
        setSavingList(value, resultAmount);
      }
    });
  }

  /// 【貯金総額画面】貯金目標毎の総額データ
  static Future<void> getSavingAmountForTarget(
      String userId, Function setSnackBar, Function setSavingTargetList) async {
    await SavingStorage.getSavingAmountForTarget(userId).then((value) async {
      if (value.isEmpty) {
        await SavingApi.getSavingAmountForTarget(
            userId, setSnackBar, setSavingTargetList);
      } else {
        setSavingTargetList(value);
      }
    });
  }

  /// 【貯金総額画面】貯金総額データ
  static Future<void> getTotalSaving(
      envClass env, Function setTotalSaving) async {
    await SavingStorage.getTotalSaving(env.getJson().toString(), setTotalSaving)
        .then((value) async {
      if (value.isEmpty) {
        await SavingApi.getTotalSaving(env, setTotalSaving);
      } else {
        setTotalSaving(value['totalSavingAmount'], value['savingDataList']);
      }
    });
  }
}
