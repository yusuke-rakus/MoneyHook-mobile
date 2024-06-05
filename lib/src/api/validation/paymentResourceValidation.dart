import 'package:money_hooks/src/class/response/paymentResource.dart';

class PaymentResourceValidation {
  static bool checkPaymentResource(PaymentResourceData payment) {
    // 未入力チェック
    if (payment.paymentName.isEmpty) {
      payment.paymentNameError = '未入力';
      return true;
    }

    // 文字数チェック
    if (payment.paymentName.length > 32) {
      payment.paymentNameError = '32文字以内';
      return true;
    }

    return false;
  }
}
