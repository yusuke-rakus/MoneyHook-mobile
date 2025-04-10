import 'package:money_hooks/src/class/changeEmailClass.dart';

import '../../class/changePasswordClass.dart';

class UserValidation {
  static bool checkChangeEmail(ChangeEmailClass emailClass) {
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

  static bool checkChangePassword(ChangePasswordClass passwordClass) {
    // 未入力チェック
    if (passwordClass.password.isEmpty) {
      passwordClass.passwordError = '未入力';
      return true;
    }
    if (passwordClass.newPassword.isEmpty) {
      passwordClass.newPasswordError = '未入力';
      return true;
    }
    if (passwordClass.newPassword2.isEmpty) {
      passwordClass.newPassword2Error = '未入力';
      return true;
    }

    // 文字チェック
    if (passwordClass.newPassword.length < 8 ||
        passwordClass.newPassword2.length < 8) {
      passwordClass.newPasswordError = '8文字以上';
      passwordClass.newPassword2Error = '8文字以上';
      return true;
    }
    if (passwordClass.newPassword.length > 32 ||
        passwordClass.newPassword2.length > 32) {
      passwordClass.newPasswordError = '32文字以下';
      passwordClass.newPassword2Error = '32文字以下';
      return true;
    }

    return false;
  }
}
