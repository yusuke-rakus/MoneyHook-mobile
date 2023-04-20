import 'package:money_hooks/src/class/transactionClass.dart';

import '../../class/monthlyTransactionClass.dart';

class monthlyTransactionValidation {
  static bool checkMonthlyTransaction(monthlyTransactionClass monthlyTransaction) {
    // 未入力チェック
    if (monthlyTransaction.monthlyTransactionName.isEmpty) {
      monthlyTransaction.monthlyTransactionNameError = '未入力';
      return true;
    }
    if (monthlyTransaction.monthlyTransactionAmount == 0) {
      monthlyTransaction.monthlyTransactionAmountError = '未入力';
      return true;
    }

    // 文字数チェック
    if (monthlyTransaction.monthlyTransactionName.length > 32) {
      monthlyTransaction.monthlyTransactionNameError = '32文字以内';
      return true;
    }

    // 桁数チェック
    if (monthlyTransaction.monthlyTransactionAmount > 9999999) {
      monthlyTransaction.monthlyTransactionAmountError = '9,999,999以内';
      return true;
    }

    return false;
  }
}
