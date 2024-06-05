import 'package:intl/intl.dart';

class TransactionClass {
  var userId = '';
  int? transactionId;
  var transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var transactionSign = -1;
  num transactionAmount = 0;
  var transactionName = '';
  int? categoryId;
  var categoryName = '';
  int? subCategoryId;
  var subCategoryName = '';
  var fixedFlg = false;
  num? paymentId;
  String? paymentName;
  bool isDisable = false;
  String transactionNameError = '';
  String transactionAmountError = '';
  late String startMonth;
  late String endMonth;

  TransactionClass();

  TransactionClass.setFields(
    this.userId,
    this.transactionId,
    this.transactionDate,
    this.transactionSign,
    this.transactionAmount,
    this.transactionName,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.fixedFlg,
    this.paymentId,
    this.paymentName,
  );

  TransactionClass.setTimelineFields(
    this.transactionId,
    this.transactionDate,
    this.transactionSign,
    this.transactionAmount,
    this.transactionName,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.fixedFlg,
    this.paymentId,
    this.paymentName,
  );

  TransactionClass.setFrequentFields(
    this.transactionName,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.fixedFlg,
  );

  TransactionClass.setTimelineChart(
      String transactionDate, int transactionAmount) {
    if (RegExp(r'^[0-9]{1,2}月').hasMatch(transactionDate)) {
      this.transactionDate = transactionDate;
    } else {
      this.transactionDate =
          '${DateFormat('yyyy-MM-dd').parse(transactionDate).month}月';
    }
    this.transactionAmount = transactionAmount.abs();
  }

  static String formatNum(int num) {
    final formatter = NumberFormat('#,###');
    return formatter.format(num);
  }

  static int formatInt(String v) {
    return int.parse(v.replaceAll(',', ''));
  }

  bool hasTransactionId() {
    return transactionId != null;
  }

  bool isDisabled() {
    return transactionName.isEmpty || transactionAmount == 0 || isDisable;
  }

  String getMonth() {
    return DateFormat('yyyy-MM-dd').parse(transactionDate).month.toString();
  }

  String getDay() {
    return DateFormat('yyyy-MM-dd').parse(transactionDate).day.toString();
  }

  Map<String, dynamic> getTransactionJson() {
    return {
      'transaction_id': transactionId,
      'transaction_date': transactionDate,
      'transaction_sign': transactionSign,
      'transaction_amount': transactionAmount,
      'transaction_name': transactionName,
      'category_id': categoryId,
      'category_name': categoryName,
      'sub_category_id': subCategoryId,
      'sub_category_name': subCategoryName,
      'fixed_flg': fixedFlg,
      'payment_id': paymentId,
      'payment_name': paymentName
    };
  }

  @override
  String toString() {
    return 'ユーザID: $userId, 取引ID: $transactionId, 取引日: $transactionDate, 金額符号: $transactionSign, 金額: $transactionAmount, 取引名: $transactionName, カテゴリID: $categoryId, カテゴリ名: $categoryName, サブカテゴリID: $subCategoryId, サブカテゴリ名: $subCategoryName, 固定費フラグ: $fixedFlg, 支払いID: $paymentId, 支払い名: $paymentName';
  }
}
