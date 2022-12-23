import '../../class/savingClass.dart';

class savingValidation {
  static bool checkSaving(savingClass saving) {
    // 未入力チェック
    if (saving.savingName.isEmpty || saving.savingAmount == 0) {
      print('er');
      return true;
    }

    // 文字数チェック
    if (saving.savingName.length > 32) {
      print('er');
      return true;
    }

    // 桁数チェック
    if (saving.savingAmount > 9999999) {
      print('er');
      return true;
    }

    print('ok');
    return false;
  }
}
