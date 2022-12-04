import 'package:money_hooks/src/class/response/response.dart';

class homeTransaction extends response {
  late int balance;
  late List<Map<String, dynamic>> categoryList;

  homeTransaction(this.balance, this.categoryList) : super('', '');

  homeTransaction.setResponse(
      super.status, super.message, this.balance, this.categoryList);

  @override
  String toString() {
    return 'homeTransaction{balance: $balance, categoryList: $categoryList}';
  }
}
