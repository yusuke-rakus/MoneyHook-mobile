import 'package:money_hooks/common/class/transactionClass.dart';

class TransactionValidation {
  static bool checkTransaction(TransactionClass transaction) {
    // 未入力チェック
    if (transaction.transactionName.isEmpty) {
      transaction.transactionNameError = '未入力';
      return true;
    }
    if (transaction.transactionAmount == 0) {
      transaction.transactionAmountError = '未入力';
      return true;
    }

    // 文字数チェック
    if (transaction.transactionName.length > 32) {
      transaction.transactionNameError = '32文字以内';
      return true;
    }

    // 桁数チェック
    if (transaction.transactionAmount > 9999999) {
      transaction.transactionAmountError = '9,999,999以内';
      return true;
    }

    return false;
  }
}
