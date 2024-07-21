import 'package:money_hooks/src/class/response/response.dart';

class PaymentResourceData extends Response {
  late num? paymentId;
  late String paymentName;
  num? paymentTypeId;
  int? paymentDate;
  int? closingDate;
  late String paymentNameError = "";
  late bool editMode = false;

  PaymentResourceData.init(this.paymentId, this.paymentName, this.paymentTypeId,
      this.paymentDate, this.closingDate)
      : super('', '');

  PaymentResourceData() : super('', '') {
    paymentId = null;
    paymentName = "";
    paymentTypeId = null;
    paymentDate = null;
    closingDate = null;
  }

  Map<String, dynamic> getPaymentJson() {
    return {
      'payment_id': paymentId,
      'payment_name': paymentName,
      'payment_type_id': paymentTypeId,
      'payment_date': paymentDate,
      'closing_date': closingDate
    };
  }

  PaymentResourceData.setResponse(
      super.status, super.message, this.paymentId, this.paymentName);
}
