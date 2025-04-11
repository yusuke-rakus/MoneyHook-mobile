import 'package:intl/intl.dart';
import 'package:money_hooks/class/transactionClass.dart';

class SearchTransactionValidation {
  static bool checkTransaction(
      TransactionClass transaction, Function setSnackBar) {
    // 未入力チェック
    if (transaction.categoryId == null) {
      setSnackBar('カテゴリを選択してください');
      return true;
    }

    // 期間チェック
    DateTime start = DateFormat('yyyy-MM-dd').parse(transaction.startMonth);
    DateTime end = DateFormat('yyyy-MM-dd').parse(transaction.endMonth);

    if (end.compareTo(start) < 0) {
      setSnackBar('日付が逆転しています');
      return true;
    }

    if (end.difference(start).inDays > 1095) {
      setSnackBar('3年未満で集計を行ってください');
      return true;
    }

    return false;
  }
}
