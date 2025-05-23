import 'package:money_hooks/common/class/response.dart';

class PaymentResourceData extends Response {
  late String? paymentId;
  late String paymentName;
  String? paymentTypeId;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentResourceData && other.paymentId == paymentId;
  }

  @override
  int get hashCode => paymentId.hashCode;
}
