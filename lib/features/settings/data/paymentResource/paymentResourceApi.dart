import 'package:dio/dio.dart';
import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/settings/class/paymentType.dart';
import 'package:money_hooks/features/settings/data/paymentResource/paymentResourceValidation.dart';

class PaymentResourceApi {
  static String rootURI = Api.rootURI;

  /// 支払い方法の追加
  static Future<void> addPaymentResource(PaymentResourceData data,
      Function reloadList, Function setSnackBar) async {
    if (PaymentResourceValidation.checkPaymentResource(data)) {
      return;
    }
    Options? option = await Api.getHeader();
    try {
      Response res = await Api.dio.post('$rootURI/payment/addPayment',
          data: {
            'payment_name': data.paymentName,
            'payment_type_id': data.paymentTypeId,
            'payment_date': data.paymentDate,
            'closing_date': data.closingDate
          },
          options: option);
      if (res.statusCode != 200) {
        // 失敗
        setSnackBar("エラーが発生しました");
      } else {
        // 成功
        reloadList();
        setSnackBar("追加が完了しました");
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
    }
  }

  /// 支払い方法の編集
  static Future<void> editPaymentResource(PaymentResourceData data,
      Function reloadList, Function setSnackBar) async {
    if (PaymentResourceValidation.checkPaymentResource(data)) {
      return;
    }
    Options? option = await Api.getHeader();
    try {
      Response res = await Api.dio.patch('$rootURI/payment/editPayment',
          data: {
            'payment_id': data.paymentId,
            'payment_name': data.paymentName,
            'payment_type_id': data.paymentTypeId,
            'payment_date': data.paymentDate,
            'closing_date': data.closingDate
          },
          options: option);
      if (res.statusCode != 200) {
        // 失敗
        setSnackBar("エラーが発生しました");
      } else {
        // 成功
        reloadList();
        setSnackBar("更新が完了しました");
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
    }
  }

  /// 支払い方法の削除
  static Future<void> deletePaymentResource(
      PaymentResourceData data, Function setSnackBar) async {
    Options? option = await Api.getHeader();
    try {
      Response res = await Api.dio.delete(
          '$rootURI/payment/deletePayment/${data.paymentId}',
          options: option);
      if (res.statusCode != 200) {
        // 失敗
        setSnackBar("エラーが発生しました");
      } else {
        // 成功
        setSnackBar("削除が完了しました");
      }
    } on DioException catch (e) {
      setSnackBar(Api.errorMessage(e));
    }
  }

  /// 支払い種類の取得
  static Future<void> getPaymentType(
      EnvClass env, Function setPaymentResourceList) async {
    Options? option = await Api.getHeader();
    try {
      Response res =
          await Api.dio.get('$rootURI/payment/getPaymentType', options: option);
      if (res.statusCode != 200) {
        // 失敗
      } else {
        // 成功
        List<PaymentTypeData> resultList = [];
        res.data['payment_type_list'].forEach((value) {
          resultList.add(PaymentTypeData.init(value['payment_type_id'],
              value['payment_type_name'], value['is_payment_due_later']));
        });
        setPaymentResourceList(resultList);
      }
    } on DioException catch (e) {
      Api.errorMessage(e);
    }
  }
}
