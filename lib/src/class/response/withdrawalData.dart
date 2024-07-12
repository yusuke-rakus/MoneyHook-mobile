import 'package:money_hooks/src/class/response/response.dart';

class WithdrawalData extends Response {
  late int paymentId;
  late String paymentName;
  late int paymentDate;
  late int withdrawalAmount;

  WithdrawalData.init(
      this.paymentId, this.paymentName, this.paymentDate, this.withdrawalAmount)
      : super('', '');

  WithdrawalData() : super('', '') {
    paymentId = 0;
    paymentName = "";
    paymentDate = 0;
    withdrawalAmount = 0;
  }

  WithdrawalData.setResponse(super.status, super.message, this.paymentId,
      this.paymentName, this.paymentDate, this.withdrawalAmount);

  Map<String, dynamic> getWithdrawalJson() {
    return {
      'payment_id': paymentId,
      'payment_name': paymentName,
      'payment_date': paymentDate,
      'withdrawal_amount': withdrawalAmount
    };
  }
}
