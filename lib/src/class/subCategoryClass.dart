class subCategoryClass {
  var _subCategoryId;
  var _subCategoryName;

  subCategoryClass(this._subCategoryId, this._subCategoryName);

  get subCategoryId => _subCategoryId;

  set subCategoryId(value) {
    _subCategoryId = value;
  }

  get subCategoryName => _subCategoryName;

  set subCategoryName(value) {
    _subCategoryName = value;
  }

  Map<String, dynamic> getSubCategoryJson() {
    return {
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
    };
  }

  @override
  String toString() {
    return 'カテゴリId: $_subCategoryId, カテゴリ名: $_subCategoryName';
  }
}
