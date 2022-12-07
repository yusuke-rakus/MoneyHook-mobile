import 'package:intl/intl.dart';

class transactionClass {
  var userId = '';
  var transactionId = '';
  var transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var transactionSign = -1;
  var transactionAmount = '';
  var transactionName = '';
  var categoryId = 1;
  var categoryName = '食費';
  var subCategoryId = 1;
  var subCategoryName = 'なし';
  var fixedFlg = false;

  transactionClass();

  transactionClass.setFields(
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
  );

  transactionClass.setTimelineFields(
    this.transactionId,
    this.transactionDate,
    this.transactionSign,
    this.transactionAmount,
    this.transactionName,
    this.categoryName,
  );

  bool hasTransactionId() {
    return transactionId.isNotEmpty ? true : false;
  }

  String getMonth() {
    return DateFormat('yyyy-MM-dd').parse(transactionDate).month.toString();
  }

  String getDay() {
    return DateFormat('yyyy-MM-dd').parse(transactionDate).day.toString();
  }

  @override
  String toString() {
    return 'ユーザID: $userId, 取引ID: $transactionId, 取引日: $transactionDate, 金額符号: $transactionSign, 金額: $transactionAmount, 取引名: $transactionName, カテゴリID: $categoryId, カテゴリ名: $categoryName, サブカテゴリID: $subCategoryId, サブカテゴリ名: $subCategoryName, 固定費フラグ: $fixedFlg';
  }
}
