import 'package:money_hooks/src/class/changeEmailClass.dart';

import '../../class/changePasswordClass.dart';

class userValidation {
  static bool checkChangeEmail(changeEmailClass emailClass) {
    // 未入力チェック
    if (emailClass.email.isEmpty) {
      emailClass.emailError = '未入力';
      return true;
    }
    if (emailClass.password.isEmpty) {
      emailClass.passwordError = '未入力';
      return true;
    }

    // 文字チェック
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailClass.email)) {
      emailClass.emailError = '形式が違います';
      return true;
    }

    return false;
  }

  static bool checkChangePassword(changePasswordClass passwordClass) {
    // 未入力チェック
    if (passwordClass.password.isEmpty) {
      passwordClass.passwordError = '未入力';
      return true;
    }
    if (passwordClass.newPasswordError.isEmpty) {
      passwordClass.newPasswordError = '未入力';
      return true;
    }
    if (passwordClass.newPassword2Error.isEmpty) {
      passwordClass.newPassword2Error = '未入力';
      return true;
    }

    // 文字チェック

    return false;
  }
}
