import 'package:intl/intl.dart';

class MonthlyTransactionClass {
  var userId = '';
  num? monthlyTransactionId;
  var monthlyTransactionName = '';
  num monthlyTransactionSign = -1;
  num monthlyTransactionAmount = 0;
  num monthlyTransactionDate = 31;
  num? categoryId;
  var categoryName = '';
  num? subCategoryId;
  var subCategoryName = '';
  String? paymentName;
  num? paymentId;

  bool includeFlg = true;
  bool isDisable = false;
  String monthlyTransactionNameError = '';
  String monthlyTransactionAmountError = '';
  String monthlyTransactionDateError = '';

  MonthlyTransactionClass();

  MonthlyTransactionClass.setFields(
      this.monthlyTransactionId,
      this.monthlyTransactionName,
      this.monthlyTransactionAmount,
      this.monthlyTransactionDate,
      this.categoryId,
      this.subCategoryId,
      this.monthlyTransactionSign,
      this.categoryName,
      this.subCategoryName,
      this.paymentId);

  static String formatNum(int num) {
    final formatter = NumberFormat('#,###');
    return formatter.format(num);
  }

  static int formatInt(String v) {
    return int.parse(v.replaceAll(',', ''));
  }

  bool hasMonthlyTransactionId() {
    return monthlyTransactionId != null ? true : false;
  }

  bool isDisabled() {
    return monthlyTransactionName.isEmpty ||
        monthlyTransactionAmount == 0 ||
        subCategoryName.isEmpty ||
        isDisable;
  }

  Map<String, dynamic> convertEditMonthlyTranJson() {
    return {
      'monthly_transaction': {
        'monthly_transaction_id': monthlyTransactionId,
        'monthly_transaction_name': monthlyTransactionName,
        'monthly_transaction_amount': monthlyTransactionAmount,
        'monthly_transaction_sign': monthlyTransactionSign,
        'monthly_transaction_date': monthlyTransactionDate,
        'category_id': categoryId,
        'sub_category_id': subCategoryId,
        'sub_category_name': subCategoryName,
        'include_flg': includeFlg,
        'payment_id': paymentId
      }
    };
  }
}
