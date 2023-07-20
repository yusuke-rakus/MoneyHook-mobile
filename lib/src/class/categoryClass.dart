import 'package:money_hooks/src/class/subCategoryClass.dart';

class categoryClass {
  var _categoryId;
  var _categoryName;
  var _subCategoryId;
  var _subCategoryName;
  late List<subCategoryClass> _subCategoryList;

  categoryClass(this._categoryId, this._categoryName);

  categoryClass.setCategoryWithSubCategory(
      this._categoryId, this._categoryName, this._subCategoryList);

  categoryClass.setDefaultValue(this._categoryId, this._categoryName,
      this._subCategoryId, this._subCategoryName);

  get categoryName => _categoryName;

  set categoryName(value) {
    _categoryName = value;
  }

  get categoryId => _categoryId;

  set categoryId(value) {
    _categoryId = value;
  }

  List<subCategoryClass> get subCategoryList => _subCategoryList;

  set subCategoryList(List<subCategoryClass> value) {
    _subCategoryList = value;
  }

  get subCategoryId => _subCategoryId;

  set subCategoryId(value) {
    _subCategoryId = value;
  }

  get subCategoryName => _subCategoryName;

  set subCategoryName(value) {
    _subCategoryName = value;
  }

  Map<String, dynamic> getCategoryJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  Map<String, dynamic> getCategoryWithSubCategoryJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'subCategoryList':
          subCategoryList.map((e) => e.getSubCategoryJson()).toList()
    };
  }

  Map<String, dynamic> getDefaultValueJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
    };
  }

  String toDefaultString() {
    return '$_categoryId,$_subCategoryId';
  }
}
