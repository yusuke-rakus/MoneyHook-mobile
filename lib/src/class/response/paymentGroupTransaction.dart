import 'package:money_hooks/src/class/response/response.dart';

class PaymentGroupTransaction extends Response {
  late num? paymentId;
  late String paymentName;
  late String paymentNameError = "";
  late bool editMode = false;

  PaymentGroupTransaction.init(this.paymentId, this.paymentName)
      : super('', '');

  PaymentGroupTransaction() : super('', '') {
    paymentId = null;
    paymentName = "";
  }

  Map<String, dynamic> getPaymentJson() {
    return {'payment_id': paymentId, 'payment_name': paymentName};
  }

  PaymentGroupTransaction.setResponse(
      super.status, super.message, this.paymentId, this.paymentName);
}
