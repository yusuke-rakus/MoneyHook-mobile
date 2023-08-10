import 'package:money_hooks/src/class/response/response.dart';

class searchTransactionData extends response {
  late int totalSpending = 0;
  late List<dynamic> monthlyVariableList = [];

  searchTransactionData.init(this.totalSpending, this.monthlyVariableList)
      : super('', '');

  searchTransactionData() : super('', '');

  searchTransactionData.setResponse(super.status, super.message,
      this.totalSpending, this.monthlyVariableList);
}
