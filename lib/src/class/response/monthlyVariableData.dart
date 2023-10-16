import 'package:money_hooks/src/class/response/response.dart';

class MonthlyVariableData extends Response {
  late int totalVariable = 0;
  late List<dynamic> monthlyVariableList = [];

  MonthlyVariableData.init(this.totalVariable, this.monthlyVariableList)
      : super('', '');

  MonthlyVariableData() : super('', '');

  MonthlyVariableData.setResponse(super.status, super.message,
      this.totalVariable, this.monthlyVariableList);
}
