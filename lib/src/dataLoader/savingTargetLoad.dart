import 'package:money_hooks/src/api/savingTargetApi.dart';
import 'package:money_hooks/src/searchStorage/savingTargetStorage.dart';

class SavingTargetLoad {
  /// 【貯金目標一覧取得】データ
  static Future<void> getSavingTargetList(
      Function setSavingTargetList, String userId) async {
    await SavingTargetStorage.getSavingTargetData(setSavingTargetList, userId)
        .then((value) async {
      if (value.isEmpty) {
        await SavingTargetApi.getSavingTargetList(setSavingTargetList, userId);
      } else {
        setSavingTargetList(value);
      }
    });
  }

  /// 【削除済み貯金目標取得】データ
  static Future<void> getDeletedSavingTarget(
      Function setSavingTargetList, Function setSnackBar, String userId) async {
    await SavingTargetStorage.getDeletedSavingTargetData(
            setSavingTargetList, userId)
        .then((value) async {
      if (value.isEmpty) {
        await SavingTargetApi.getDeletedSavingTarget(
            setSavingTargetList, setSnackBar, userId);
      } else {
        setSavingTargetList(value);
      }
    });
  }
}
