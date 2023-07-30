import 'package:money_hooks/src/api/savingApi.dart';
import 'package:money_hooks/src/searchStorage/savingStorage.dart';

import '../env/envClass.dart';

class SavingLoad {
  /// 【貯金一覧画面】データ
  static void getMonthlySavingData(envClass env, Function setLoading,
      Function setSnackBar, Function setSavingList) async {
    SavingStorage.getMonthlySavingData(env.getJson().toString(), setLoading)
        .then((value) async {
      if (value.isEmpty) {
        SavingApi.getMonthlySavingData(
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
  static void getSavingAmountForTarget(String userId, Function setLoading,
      Function setSnackBar, Function setSavingTargetList) async {
    SavingStorage.getSavingAmountForTarget(userId, setLoading)
        .then((value) async {
      if (value.isEmpty) {
        SavingApi.getSavingAmountForTarget(
            userId, setLoading, setSnackBar, setSavingTargetList);
      } else {
        setSavingTargetList(value);
      }
    });
  }

  /// 【貯金総額画面】貯金総額データ
  static void getTotalSaving(envClass env, Function setTotalSaving) async {
    SavingStorage.getTotalSaving(env.getJson().toString(), setTotalSaving)
        .then((value) async {
      if (value.isEmpty) {
        SavingApi.getTotalSaving(env, setTotalSaving);
      } else {
        setTotalSaving(value['totalSavingAmount'], value['savingDataList']);
      }
    });
  }
}
