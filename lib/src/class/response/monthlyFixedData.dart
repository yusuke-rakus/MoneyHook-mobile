import 'package:money_hooks/src/class/response/response.dart';
import 'package:money_hooks/src/class/transactionClass.dart';

class MonthlyFixedData extends Response {
  late int disposableIncome = 0;
  late List<MFCategoryClass> monthlyFixedList = [];

  MonthlyFixedData.init(this.disposableIncome, this.monthlyFixedList)
      : super('', '');

  MonthlyFixedData() : super('', '');

  MonthlyFixedData.setResponse(super.status, super.message,
      this.disposableIncome, this.monthlyFixedList);

  MonthlyFixedData.setMVList({required this.monthlyFixedList}) : super('', '');

  List<dynamic> toJson() {
    return monthlyFixedList.map((category) => category.toJson()).toList();
  }

  factory MonthlyFixedData.fromJson(List<Map<String, dynamic>> json) {
    return MonthlyFixedData.setMVList(
      monthlyFixedList: (json as List)
          .map((category) => MFCategoryClass.fromJson(category))
          .toList(),
    );
  }

  @override
  String toString() {
    return '$disposableIncome, $monthlyFixedList';
  }
}

class MFCategoryClass {
  late String categoryId;
  late String categoryName;
  late int totalCategoryAmount;
  late List<TransactionClass> transactionList;

  MFCategoryClass(
      {required this.categoryId,
      required this.categoryName,
      required this.totalCategoryAmount,
      required this.transactionList});

  MFCategoryClass.init(
      Map<String, dynamic> category, List<TransactionClass> tranList) {
    categoryId = category['category_id'];
    categoryName = category['category_name'];
    totalCategoryAmount = category['total_category_amount'];
    transactionList = tranList;
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'totalCategoryAmount': totalCategoryAmount,
      'transactionList': transactionList.map((tran) => tran.toMFJson()).toList()
    };
  }

  factory MFCategoryClass.fromJson(Map<String, dynamic> json) {
    return MFCategoryClass(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      totalCategoryAmount: json['totalCategoryAmount'],
      transactionList: (json['transactionList'] as List)
          .map((tran) => TransactionClass.mfFromJson(tran))
          .toList(),
    );
  }

  @override
  String toString() {
    return '$categoryName, $totalCategoryAmount, $transactionList';
  }
}
