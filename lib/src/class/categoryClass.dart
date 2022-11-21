class categoryClass {
  var _categoryId;
  var _categoryName;

  categoryClass(this._categoryId, this._categoryName);

  get categoryName => _categoryName;

  set categoryName(value) {
    _categoryName = value;
  }

  get categoryId => _categoryId;

  set categoryId(value) {
    _categoryId = value;
  }

  @override
  String toString() {
    return 'カテゴリId: $_categoryId, カテゴリ名: $_categoryName';
  }
}
