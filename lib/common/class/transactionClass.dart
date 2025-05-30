import 'package:intl/intl.dart';

class TransactionClass {
  var userId = '';
  String? transactionId;
  var transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var transactionSign = -1;
  num transactionAmount = 0;
  var transactionName = '';
  String? categoryId;
  var categoryName = '';
  String? subCategoryId;
  var subCategoryName = '';
  var fixedFlg = false;
  String? paymentId;
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
    this.paymentId,
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

  TransactionClass.setMonthlyVariableData(Map<String, dynamic> tran) {
    transactionId = tran['transaction_id'];
    transactionDate = tran['transaction_date'];
    transactionSign = tran['transaction_amount'];
    transactionAmount = tran['transaction_amount'];
    transactionName = tran['transaction_name'];
    paymentId = tran['payment_id'];
    paymentName = tran['payment_name'];
  }

  TransactionClass.setMonthlyFixedData(Map<String, dynamic> tran) {
    transactionId = tran['transaction_id'];
    transactionName = tran['transaction_name'];
    transactionAmount = tran['transaction_amount'];
    transactionDate = tran['transaction_date'];
    subCategoryId = tran['sub_category_id'];
    subCategoryName = tran['sub_category_name'];
    fixedFlg = tran['fixed_flg'];
    paymentId = tran['payment_id'];
    paymentName = tran['payment_name'];
  }

  TransactionClass.setMVTran(
      {required this.transactionId,
      required this.transactionName,
      required this.transactionAmount,
      required this.transactionDate,
      required this.paymentId,
      required this.paymentName});

  TransactionClass.setMFTran(
      {required this.transactionId,
      required this.transactionName,
      required this.transactionAmount,
      required this.transactionDate,
      required this.subCategoryId,
      required this.subCategoryName,
      required this.fixedFlg,
      required this.paymentId,
      required this.paymentName});

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

  Map<String, dynamic> toMVJson() {
    return {
      'transactionId': transactionId,
      'transactionName': transactionName,
      'transactionAmount': transactionAmount,
      'transactionDate': transactionDate,
      'paymentId': paymentId,
      'paymentName': paymentName
    };
  }

  Map<String, dynamic> toMFJson() {
    return {
      'transactionId': transactionId,
      'transactionName': transactionName,
      'transactionAmount': transactionAmount,
      'transactionDate': transactionDate,
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
      'fixedFlg': fixedFlg,
      'paymentId': paymentId,
      'paymentName': paymentName
    };
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

  factory TransactionClass.mvFromJson(Map<String, dynamic> json) {
    return TransactionClass.setMVTran(
      transactionId: json['transactionId'],
      transactionName: json['transactionName'],
      transactionAmount: json['transactionAmount'],
      transactionDate: json['transactionDate'],
      paymentId: json['paymentId'],
      paymentName: json['paymentName'],
    );
  }

  factory TransactionClass.mfFromJson(Map<String, dynamic> json) {
    return TransactionClass.setMFTran(
      transactionId: json['transactionId'],
      transactionName: json['transactionName'],
      transactionAmount: json['transactionAmount'],
      transactionDate: json['transactionDate'],
      subCategoryId: json['subCategoryId'],
      subCategoryName: json['subCategoryName'],
      fixedFlg: json['fixedFlg'],
      paymentId: json['paymentId'],
      paymentName: json['paymentName'],
    );
  }

  @override
  String toString() {
    return 'ユーザID: $userId, 取引ID: $transactionId, 取引日: $transactionDate, 金額符号: $transactionSign, 金額: $transactionAmount, 取引名: $transactionName, カテゴリ: ($categoryId, $categoryName), サブカテゴリ: ($subCategoryId, $subCategoryName), 固定費フラグ: $fixedFlg, 支払い: ($paymentId, $paymentName)';
  }
}
