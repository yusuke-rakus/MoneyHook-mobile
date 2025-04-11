import 'package:money_hooks/class/response/response.dart';

class PaymentTypeData extends Response {
  String? paymentTypeId;
  late String paymentTypeName;
  late bool isPaymentDueLater;

  PaymentTypeData.init(
      this.paymentTypeId, this.paymentTypeName, this.isPaymentDueLater)
      : super('', '');

  PaymentTypeData() : super('', '') {
    paymentTypeId = null;
    paymentTypeName = "";
    isPaymentDueLater = false;
  }

  Map<String, dynamic> getPaymentJson() {
    return {
      'payment_type_id': paymentTypeId,
      'payment_type_name': paymentTypeName,
      'is_payment_due_later': isPaymentDueLater
    };
  }

  PaymentTypeData.setResponse(super.status, super.message, this.paymentTypeId,
      this.paymentTypeName, this.isPaymentDueLater);
}
