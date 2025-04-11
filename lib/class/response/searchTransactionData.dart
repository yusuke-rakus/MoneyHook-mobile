import 'package:money_hooks/class/response/response.dart';

class SearchTransactionData extends Response {
  late int totalSpending = 0;
  late List<dynamic> monthlyVariableList = [];

  SearchTransactionData.init(this.totalSpending, this.monthlyVariableList)
      : super('', '');

  SearchTransactionData() : super('', '');

  SearchTransactionData.setResponse(super.status, super.message,
      this.totalSpending, this.monthlyVariableList);
}
