import 'package:money_hooks/common/class/monthlyTransactionClass.dart';

class MonthlyTransactionValidation {
  static bool checkMonthlyTransaction(
      MonthlyTransactionClass monthlyTransaction) {
    // 未入力チェック
    if (monthlyTransaction.monthlyTransactionName.isEmpty) {
      monthlyTransaction.monthlyTransactionNameError = '未入力';
      return true;
    }
    if (monthlyTransaction.monthlyTransactionAmount == 0) {
      monthlyTransaction.monthlyTransactionAmountError = '未入力';
      return true;
    }
    if (monthlyTransaction.monthlyTransactionDate == 0) {
      monthlyTransaction.monthlyTransactionDateError = '未入力';
      return true;
    }

    // 日付チェック
    if (monthlyTransaction.monthlyTransactionDate > 31) {
      monthlyTransaction.monthlyTransactionDateError = '31以内';
      return true;
    }

    // 桁数チェック
    if (monthlyTransaction.monthlyTransactionAmount > 9999999) {
      monthlyTransaction.monthlyTransactionAmountError = '9,999,999以内';
      return true;
    }

    // 文字数チェック
    if (monthlyTransaction.monthlyTransactionName.length > 33) {
      monthlyTransaction.monthlyTransactionNameError = '32文字以内';
      return true;
    }

    return false;
  }
}
