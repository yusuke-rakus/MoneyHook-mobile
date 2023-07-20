class subCategoryClass {
  var _subCategoryId;
  var _subCategoryName;
  var _enable;

  subCategoryClass(this._subCategoryId, this._subCategoryName);

  subCategoryClass.setFullFields(this._subCategoryId, this._subCategoryName,
      this._enable);

  get subCategoryId => _subCategoryId;

  set subCategoryId(value) {
    _subCategoryId = value;
  }

  get subCategoryName => _subCategoryName;

  set subCategoryName(value) {
    _subCategoryName = value;
  }

  get enable => _enable;

  set enable(value) {
    _enable = value;
  }

  Map<String, dynamic> getSubCategoryJson() {
    return {
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
      'enable': enable,
    };
  }

  @override
  String toString() {
    return 'subCategoryClass{_subCategoryId: $_subCategoryId, _subCategoryName: $_subCategoryName, _enable: $_enable}';
  }
}
