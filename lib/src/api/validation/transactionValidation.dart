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

    // 桁数チェック
    
    print('ok');
    return false;
  }
}
