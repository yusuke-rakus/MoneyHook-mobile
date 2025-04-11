import 'package:money_hooks/class/response/response.dart';
import 'package:money_hooks/class/transactionClass.dart';

class TimelineTransaction extends Response {
  List<TransactionClass> transactionList = [];

  TimelineTransaction.init(this.transactionList) : super('', '');

  TimelineTransaction() : super('', '');

  TimelineTransaction.setResponse(
      super.status, super.message, this.transactionList);

  @override
  String toString() {
    return 'timelineTransaction{transactionList: $transactionList}';
  }
}
