import 'package:intl/intl.dart';

class savingClass {
  var _userId = '';
  var _savingId = '';
  var _savingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var _savingName = '';
  var _savingAmount = '123';
  var _savingTargetId = '';
  var _savingTargetName = '';

  savingClass();

  savingClass.setFields(
      this._userId,
      this._savingDate,
      this._savingName,
      this._savingId,
      this._savingAmount,
      this._savingTargetId,
      this._savingTargetName);

  bool hasSavingId() {
    return _savingId.isNotEmpty ? true : false;
  }

  get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  get savingId => _savingId;

  set savingId(value) {
    _savingId = value;
  }

  get savingDate => _savingDate;

  set savingDate(value) {
    _savingDate = value;
  }

  get savingName => _savingName;

  set savingName(value) {
    _savingName = value;
  }

  get savingAmount => _savingAmount;

  set savingAmount(value) {
    _savingAmount = value;
  }

  get savingTargetId => _savingTargetId;

  set savingTargetId(value) {
    _savingTargetId = value;
  }

  get savingTargetName => _savingTargetName;

  set savingTargetName(value) {
    _savingTargetName = value;
  }

  @override
  String toString() {
    return 'ユーザーID: $_userId, 貯金ID: $_savingId, 貯金日: $_savingDate, 貯金名: $_savingName, 金額: $_savingAmount, 貯金目標ID: $_savingTargetId, 貯金目標: $_savingTargetName';
  }
}
