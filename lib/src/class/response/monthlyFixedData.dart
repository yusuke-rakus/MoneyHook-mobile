import 'package:money_hooks/src/class/response/response.dart';

class MonthlyFixedData extends Response {
  late int disposableIncome = 0;
  late List<dynamic> monthlyFixedList = [];

  MonthlyFixedData.init(this.disposableIncome, this.monthlyFixedList)
      : super('', '');

  MonthlyFixedData() : super('', '');

  MonthlyFixedData.setResponse(super.status, super.message,
      this.disposableIncome, this.monthlyFixedList);
}
