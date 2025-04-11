import 'package:dio/dio.dart';
import 'package:money_hooks/class/transactionClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';

class CommonTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  /// レコメンドリストの取得
  static Future<void> getFrequentTransactionName(
      EnvClass env, Function setRecommendList) async {
    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio
            .get('$rootURI/getFrequentTransactionName', options: option);
        if (res.statusCode != 200) {
          // 失敗
        } else {
          // 成功
          List<TransactionClass> resultList = [];
          res.data['transaction_list'].forEach((value) {
            TransactionClass tran = TransactionClass.setFrequentFields(
                value['transaction_name'],
                value['category_id'],
                value['category_name'],
                value['sub_category_id'],
                value['sub_category_name'],
                value['fixed_flg'],
                value['payment_id']);
            resultList.add(tran);
          });
          setRecommendList(resultList);
        }
      } on DioException catch (e) {
        Api.errorMessage(e);
      }
    });
  }
}
