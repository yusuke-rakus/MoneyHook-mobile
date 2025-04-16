import 'package:money_hooks/common/class/response.dart';
import 'package:money_hooks/common/class/transactionClass.dart';

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
