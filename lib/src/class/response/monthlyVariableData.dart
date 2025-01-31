import 'package:money_hooks/src/class/response/response.dart';
import 'package:money_hooks/src/class/transactionClass.dart';

class MonthlyVariableData extends Response {
  late int totalVariable = 0;
  late List<MVCategoryClass> monthlyVariableList = [];

  MonthlyVariableData.init(this.totalVariable, this.monthlyVariableList)
      : super('', '');

  MonthlyVariableData() : super('', '');

  MonthlyVariableData.setResponse(super.status, super.message,
      this.totalVariable, this.monthlyVariableList);

  MonthlyVariableData.setMVList({required this.monthlyVariableList})
      : super('', '');

  List<dynamic> toJson() {
    return monthlyVariableList.map((category) => category.toJson()).toList();
  }

  factory MonthlyVariableData.fromJson(List<Map<String, dynamic>> json) {
    return MonthlyVariableData.setMVList(
      monthlyVariableList: (json as List)
          .map((category) => MVCategoryClass.fromJson(category))
          .toList(),
    );
  }

  @override
  String toString() {
    return '$totalVariable, $monthlyVariableList';
  }
}

class MVCategoryClass {
  late int categoryId;
  late String categoryName;
  late int categoryTotalAmount;
  late List<MVSubCategoryClass> subCategoryList;

  MVCategoryClass(
      {required this.categoryId,
      required this.categoryName,
      required this.categoryTotalAmount,
      required this.subCategoryList});

  MVCategoryClass.init(Map<String, dynamic> category,
      List<MVSubCategoryClass> MVSubCategoryList) {
    categoryId = category['category_id'];
    categoryName = category['category_name'];
    categoryTotalAmount = category['category_total_amount'];
    subCategoryList = MVSubCategoryList;
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryTotalAmount': categoryTotalAmount,
      'subCategoryList':
          subCategoryList.map((subCategory) => subCategory.toJson()).toList()
    };
  }

  factory MVCategoryClass.fromJson(Map<String, dynamic> json) {
    return MVCategoryClass(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryTotalAmount: json['categoryTotalAmount'],
      subCategoryList: (json['subCategoryList'] as List)
          .map((subCategory) => MVSubCategoryClass.fromJson(subCategory))
          .toList(),
    );
  }

  @override
  String toString() {
    return '$categoryName, $categoryTotalAmount, $subCategoryList';
  }
}

class MVSubCategoryClass {
  late int subCategoryId;
  late String subCategoryName;
  late int subCategoryTotalAmount;
  late List<TransactionClass> transactionList;

  MVSubCategoryClass(
      {required this.subCategoryId,
      required this.subCategoryName,
      required this.subCategoryTotalAmount,
      required this.transactionList});

  MVSubCategoryClass.init(
      Map<String, dynamic> subCategory, List<TransactionClass> tranList) {
    subCategoryId = subCategory['sub_category_id'];
    subCategoryName = subCategory['sub_category_name'];
    subCategoryTotalAmount = subCategory['sub_category_total_amount'];
    transactionList = tranList;
  }

  Map<String, dynamic> toJson() {
    return {
      'subCategoryId': subCategoryId,
      'subCategoryName': subCategoryName,
      'subCategoryTotalAmount': subCategoryTotalAmount,
      'transactionList': transactionList.map((tran) => tran.toMVJson()).toList()
    };
  }

  factory MVSubCategoryClass.fromJson(Map<String, dynamic> json) {
    return MVSubCategoryClass(
      subCategoryId: json['subCategoryId'],
      subCategoryName: json['subCategoryName'],
      subCategoryTotalAmount: json['subCategoryTotalAmount'],
      transactionList: (json['transactionList'] as List)
          .map((tran) => TransactionClass.mvFromJson(tran))
          .toList(),
    );
  }

  @override
  String toString() {
    return '$subCategoryId, $subCategoryName, $subCategoryTotalAmount, $transactionList';
  }
}
