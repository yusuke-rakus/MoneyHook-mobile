import '../../class/savingTargetClass.dart';

class savingTargetValidation {
  static bool checkSavingTarget(SavingTargetClass savingTarget) {
    // 未入力チェック
    if (savingTarget.savingTargetName.isEmpty) {
      savingTarget.savingTargetNameError = '未入力';
      return true;
    }
    if (savingTarget.targetAmount == 0) {
      savingTarget.targetAmountError = '未入力';
      return true;
    }

    // 文字数チェック
    if (savingTarget.savingTargetName.length > 32) {
      savingTarget.savingTargetNameError = '32文字以内';
      return true;
    }

    // 桁数チェック
    if (savingTarget.targetAmount > 9999999) {
      savingTarget.targetAmountError = '9,999,999以内';
      return true;
    }

    return false;
  }
}
