import '../../class/savingTargetClass.dart';

class savingTargetValidation {
  static bool checkSavingTarget(savingTargetClass savingTarget) {
    // 未入力チェック
    if (savingTarget.savingTargetName.isEmpty ||
        savingTarget.targetAmount == 0) {
      print('er');
      return true;
    }

    //文字数チェック
    if (savingTarget.savingTargetName.length > 32) {
      print('er');
      return true;
    }

    if (savingTarget.targetAmount > 99999999) {
      print('er');
      return true;
    }
    print('ok');
    return false;
  }
}
