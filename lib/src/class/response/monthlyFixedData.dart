import 'package:money_hooks/src/class/response/response.dart';

class monthlyFixedData extends response {
  late int disposableIncome = 0;
  late List<dynamic> monthlyFixedList = [];

  monthlyFixedData.init(this.disposableIncome, this.monthlyFixedList)
      : super('', '');

  monthlyFixedData() : super('', '');

  monthlyFixedData.setResponse(super.status, super.message,
      this.disposableIncome, this.monthlyFixedList);
}
