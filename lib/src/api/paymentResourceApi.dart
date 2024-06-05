import 'package:dio/dio.dart';
import 'package:money_hooks/src/api/validation/paymentResourceValidation.dart';
import 'package:money_hooks/src/env/envClass.dart';

import '../class/response/paymentResource.dart';
import '../searchStorage/paymentResourceStorage.dart';
import 'api.dart';

class PaymentResourceApi {
  static String rootURI = Api.rootURI;

  /// 支払い方法一覧の取得
  static Future<void> getPaymentResourceList(
      envClass env, Function setPaymentResourceList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res =
            await Api.dio.get('$rootURI/payment/getPayment', options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          setPaymentResourceList(res.data['payment_list']);
          if (res.data['payment_list'] != null) {
            PaymentResourceStorage.savePaymentResourceList(
                res.data['payment_list'], env.getUserJson().toString());
          }
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }

  /// 支払い方法の追加
  static Future<void> addPaymentResource(PaymentResourceData data,
      Function reloadList, Function setSnackBar) async {
    if (PaymentResourceValidation.checkPaymentResource(data)) {
      return;
    }
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.post('$rootURI/payment/addPayment',
            data: {'payment_name': data.paymentName}, options: option);
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
    });
  }

  /// 支払い方法の編集
  static Future<void> editPaymentResource(PaymentResourceData data,
      Function reloadList, Function setSnackBar) async {
    if (PaymentResourceValidation.checkPaymentResource(data)) {
      return;
    }
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.patch('$rootURI/payment/editPayment',
            data: {
              'payment_id': data.paymentId,
              'payment_name': data.paymentName
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
    });
  }

  /// 支払い方法の削除
  static Future<void> deletePaymentResource(
      PaymentResourceData data, Function setSnackBar) async {
    await Api.getHeader().then((option) async {
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
    });
  }
}
