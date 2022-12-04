import 'package:money_hooks/src/class/response/response.dart';
import 'package:money_hooks/src/class/transactionClass.dart';

class timelineTransaction extends response {
  List<transactionClass> transactionList;

  timelineTransaction(this.transactionList) : super('', '');

  timelineTransaction.setResponse(
      super.status, super.message, this.transactionList);

  @override
  String toString() {
    return 'timelineTransaction{transactionList: $transactionList}';
  }
}
