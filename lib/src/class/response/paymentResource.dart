import 'package:money_hooks/src/class/response/response.dart';

class PaymentResourceData extends Response {
  late num? paymentId;
  late String paymentName;
  late String paymentNameError = "";
  late bool editMode = false;

  PaymentResourceData.init(this.paymentId, this.paymentName) : super('', '');

  PaymentResourceData() : super('', '') {
    paymentId = null;
    paymentName = "";
  }

  Map<String, dynamic> getPaymentJson() {
    return {'payment_id': paymentId, 'payment_name': paymentName};
  }

  PaymentResourceData.setResponse(
      super.status, super.message, this.paymentId, this.paymentName);
}
