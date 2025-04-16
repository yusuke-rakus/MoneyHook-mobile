import 'package:money_hooks/common/class/response.dart';

class HomeTransaction extends Response {
  late int balance = 0;
  late List<dynamic> categoryList = [];

  HomeTransaction.init(this.balance, this.categoryList) : super('', '');

  HomeTransaction() : super('', '');

  HomeTransaction.setResponse(
      super.status, super.message, this.balance, this.categoryList);

  @override
  String toString() {
    return 'homeTransaction{balance: $balance, category_list: $categoryList}';
  }
}
