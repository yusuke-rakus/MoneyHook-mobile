import 'package:money_hooks/src/class/response/response.dart';

class PaymentResourceData extends Response {
  late num? paymentId;
  late String paymentName;
  late String PaymentNameError = "";
  late bool editMode = false;

  PaymentResourceData.init(this.paymentId, this.paymentName) : super('', '');

  PaymentResourceData() : super('', '');

  PaymentResourceData.setResponse(
      super.status, super.message, this.paymentId, this.paymentName);
}
