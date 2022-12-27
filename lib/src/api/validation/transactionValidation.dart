import 'package:money_hooks/src/class/transactionClass.dart';

class transactionValidation {
  static bool checkTransaction(transactionClass transaction) {
    // 未入力チェック
    if (transaction.transactionName.isEmpty ||
        transaction.transactionAmount == 0) {
      print('er');
      return true;
    }

    // 文字数チェック
    if (transaction.transactionName.length > 32) {
      print('er');
      return true;
    }

    // 桁数チェック
    if (transaction.transactionAmount > 9999999) {
      print('er');
      return true;
    }

    print('ok');
    return false;
  }
}
