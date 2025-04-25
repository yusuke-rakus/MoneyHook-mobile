import 'package:money_hooks/common/class/response.dart';

class HomeTransaction extends Response {
  late int balance = 0;
  late List<Category> categoryList = [];

  HomeTransaction.init(this.balance, this.categoryList) : super('', '');

  HomeTransaction() : super('', '');

  HomeTransaction.setResponse(
      super.status, super.message, this.balance, this.categoryList);

  @override
  String toString() {
    return 'homeTransaction{balance: $balance, category_list: $categoryList}';
  }
}

class Category {
  late String categoryName;
  late int categoryTotalAmount;
  late List<SubCategory> subCategoryList;

  Category(
      {required this.categoryName,
      required this.categoryTotalAmount,
      required this.subCategoryList});

  @override
  String toString() {
    return 'categoryName: $categoryName, categoryTotalAmount: $categoryTotalAmount, subCategoryList: $subCategoryList';
  }
}

class SubCategory {
  late String subCategoryName;
  late int subCategoryTotalAmount;

  SubCategory(
      {required this.subCategoryName, required this.subCategoryTotalAmount});

  @override
  String toString() {
    return 'subCategoryName: $subCategoryName, subCategoryTotalAmount: $subCategoryTotalAmount';
  }
}
