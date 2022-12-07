import 'package:money_hooks/src/class/response/response.dart';

class homeTransaction extends response {
  late int balance = 0;
  late List<dynamic> categoryList = [];

  homeTransaction.init(this.balance, this.categoryList) : super('', '');

  homeTransaction() : super('', '');

  homeTransaction.setResponse(
      super.status, super.message, this.balance, this.categoryList);

  @override
  String toString() {
    return 'homeTransaction{balance: $balance, categoryList: $categoryList}';
  }
}
