import '../../class/savingClass.dart';

class savingValidation {
  static bool checkSaving(savingClass saving) {
    // 未入力チェック
    if (saving.savingName.isEmpty) {
      saving.savingNameError = '未入力';
      return true;
    }
    if (saving.savingAmount == 0) {
      saving.savingAmountError = '未入力';
      return true;
    }

    // 文字数チェック
    if (saving.savingName.length > 32) {
      saving.savingNameError = '32文字以内';
      return true;
    }

    // 桁数チェック
    if (saving.savingAmount > 9999999) {
      saving.savingAmountError = '9,999,999以内';
      return true;
    }

    return false;
  }
}
