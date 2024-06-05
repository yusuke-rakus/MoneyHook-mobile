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

  PaymentResourceData.setResponse(
      super.status, super.message, this.paymentId, this.paymentName);
}
