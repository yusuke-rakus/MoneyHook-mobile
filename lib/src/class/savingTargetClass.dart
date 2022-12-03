class savingTargetClass {
  var _userId = '';
  var _savingTargetId = '';
  var _savingTargetName = '';
  var _targetAmount = '';
  var _savingTotalAmount = '';
  var _savingCount = '';

  savingTargetClass();

  savingTargetClass.setFields(
    this._userId,
    this._savingTargetId,
    this._savingTargetName,
    this._targetAmount,
    this._savingTotalAmount,
    this._savingCount,
  );

  savingTargetClass.setTargetFields(
    this._savingTargetId,
    this._savingTargetName,
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

  get savingTotalAmount => _savingTotalAmount;

  set savingTotalAmount(value) {
    _savingTotalAmount = value;
  }

  get savingCount => _savingCount;

  set savingCount(value) {
    _savingCount = value;
  }

  @override
  String toString() {
    return 'ユーザID: $_userId, 貯金目標ID: $_savingTargetId, 貯金目標: $_savingTargetName, 目標金額: $_targetAmount, 貯金額: $_savingTotalAmount, 貯金回数: $_savingCount';
  }
}
