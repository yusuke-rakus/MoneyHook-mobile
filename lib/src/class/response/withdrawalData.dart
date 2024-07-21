import 'package:intl/intl.dart';
import 'package:money_hooks/src/class/response/response.dart';

class WithdrawalData extends Response {
  late int paymentId;
  late String paymentName;
  late int paymentDate;
  late DateTime? aggregationStartDate;
  late DateTime? aggregationEndDate;
  late int withdrawalAmount;

  WithdrawalData.init(
    this.paymentId,
    this.paymentName,
    this.paymentDate,
    this.aggregationStartDate,
    this.aggregationEndDate,
    this.withdrawalAmount,
  ) : super('', '');

  WithdrawalData() : super('', '') {
    paymentId = 0;
    paymentName = "";
    paymentDate = 0;
    aggregationStartDate = null;
    aggregationEndDate = null;
    withdrawalAmount = 0;
  }

  WithdrawalData.setResponse(
      super.status,
      super.message,
      this.paymentId,
      this.paymentName,
      this.paymentDate,
      this.aggregationStartDate,
      this.aggregationEndDate,
      this.withdrawalAmount);

  Map<String, dynamic> getWithdrawalJson() {
    return {
      'payment_id': paymentId,
      'payment_name': paymentName,
      'payment_date': paymentDate,
      'aggregation_start_date':
          DateFormat('yyyy-MM-dd').format(aggregationStartDate!),
      'aggregation_end_date':
          DateFormat('yyyy-MM-dd').format(aggregationEndDate!),
      'withdrawal_amount': withdrawalAmount
    };
  }
}
