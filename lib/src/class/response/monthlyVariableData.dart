import 'package:money_hooks/src/class/response/response.dart';

class monthlyVariableData extends response {
  late int totalVariable = 0;
  late List<dynamic> monthlyVariableList = [];

  monthlyVariableData.init(this.totalVariable, this.monthlyVariableList)
      : super('', '');

  monthlyVariableData() : super('', '');

  monthlyVariableData.setResponse(super.status, super.message,
      this.totalVariable, this.monthlyVariableList);
}
