import 'package:intl/intl.dart';

class transactionClass {
  var _userId = '';
  var _transactionId = '';
  var _transactionDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var _transactionSign = -1;
  var _transactionAmount = '';
  var _transactionName = '';
  var _categoryId = 1;
  var _categoryName = '食費';
  var _subCategoryId = 1;
  var _subCategoryName = 'なし';
  var _fixedFlg = false;

  transactionClass();

  transactionClass.setFields(
    this._userId,
    this._transactionId,
    this._transactionDate,
    this._transactionSign,
    this._transactionAmount,
    this._transactionName,
    this._categoryId,
    this._categoryName,
    this._subCategoryId,
    this._subCategoryName,
    this._fixedFlg,
  );

  transactionClass.setTimelineFields(
    this._transactionId,
    this._transactionDate,
    this._transactionSign,
    this._transactionAmount,
    this._transactionName,
    this._categoryName,
  );

  bool hasTransactionId() {
    return _transactionId.isNotEmpty ? true : false;
  }

  String getMonth() {
    return DateFormat('yyyy-MM-dd').parse(_transactionDate).month.toString();
  }

  String getDay() {
    return DateFormat('yyyy-MM-dd').parse(_transactionDate).day.toString();
  }

  get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  get transactionId => _transactionId;

  set transactionId(value) {
    _transactionId = value;
  }

  get transactionDate => _transactionDate;

  set transactionDate(value) {
    _transactionDate = value;
  }

  get transactionSign => _transactionSign;

  set transactionSign(value) {
    _transactionSign = value;
  }

  get transactionAmount => _transactionAmount;

  set transactionAmount(value) {
    _transactionAmount = value;
  }

  get transactionName => _transactionName;

  set transactionName(value) {
    _transactionName = value;
  }

  get categoryId => _categoryId;

  set categoryId(value) {
    _categoryId = value;
  }

  get categoryName => _categoryName;

  set categoryName(value) {
    _categoryName = value;
  }

  get subCategoryId => _subCategoryId;

  set subCategoryId(value) {
    _subCategoryId = value;
  }

  get subCategoryName => _subCategoryName;

  set subCategoryName(value) {
    _subCategoryName = value;
  }

  get fixedFlg => _fixedFlg;

  set fixedFlg(value) {
    _fixedFlg = value;
  }

  @override
  String toString() {
    return 'ユーザID: $_userId, 取引ID: $_transactionId, 取引日: $_transactionDate, 金額符号: $_transactionSign, 金額: $_transactionAmount, 取引名: $_transactionName, カテゴリID: $_categoryId, カテゴリ名: $_categoryName, サブカテゴリID: $_subCategoryId, サブカテゴリ名: $_subCategoryName, 固定費フラグ: $_fixedFlg';
  }
}
