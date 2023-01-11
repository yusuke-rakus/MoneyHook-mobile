import 'package:intl/intl.dart';

class monthlyTransactionClass {
  var userId = '';
  var monthlyTransactionId = '';
  var monthlyTransactionName = '';
  num monthlyTransactionSign = -1;
  num monthlyTransactionAmount = 0;
  num monthlyTransactionDate = 31;
  var categoryId = '';
  var categoryName = '';
  var subCategoryId = '';
  var subCategoryName = '';
  bool includeFlg = true;
  String monthlyTransactionNameError = '';
  String monthlyTransactionAmountError = '';

  monthlyTransactionClass();

  monthlyTransactionClass.setFields(
      this.monthlyTransactionId,
      this.monthlyTransactionName,
      this.monthlyTransactionAmount,
      this.monthlyTransactionDate,
      this.categoryId,
      this.subCategoryId,
      this.includeFlg,
      this.monthlyTransactionSign,
      this.categoryName,
      this.subCategoryName);

  static String formatNum(int num) {
    final formatter = NumberFormat('#,###');
    return formatter.format(num);
  }

  static int formatInt(String v) {
    return int.parse(v.replaceAll(',', ''));
  }

  bool hasMonthlyTransactionId() {
    return monthlyTransactionId.isNotEmpty ? true : false;
  }
}
