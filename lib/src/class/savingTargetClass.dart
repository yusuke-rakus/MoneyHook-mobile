class savingTargetClass {
  var _userId = '';
  var _savingTargetId = '';
  var _savingTargetName = 'サンプル目標';
  var _targetAmount = '10000';

  savingTargetClass();

  savingTargetClass.setFields(
    this._userId,
    this._savingTargetId,
    this._savingTargetName,
    this._targetAmount,
  );

  bool hasTargetId() {
    return _savingTargetId.isNotEmpty ? true : false;
  }

  get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  get savingTargetId => _savingTargetId;

  set savingTargetId(value) {
    _savingTargetId = value;
  }

  get savingTargetName => _savingTargetName;

  set savingTargetName(value) {
    _savingTargetName = value;
  }

  get targetAmount => _targetAmount;

  set targetAmount(value) {
    _targetAmount = value;
  }

  @override
  String toString() {
    return 'ユーザID: $_userId, 貯金目標ID: $_savingTargetId, 貯金目標: $_savingTargetName, 目標金額: $_targetAmount';
  }
}
