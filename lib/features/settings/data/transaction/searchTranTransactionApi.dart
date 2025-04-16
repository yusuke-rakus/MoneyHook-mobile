import 'package:dio/dio.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/settings/data/transaction/searchTransactionValidation.dart';

class SearchTranTransactionApi {
  static String rootURI = '${Api.rootURI}/transaction';

  /// カテゴリ毎の支出総額を取得
  static Future<void> getTotalSpending(
      EnvClass env,
      TransactionClass transaction,
      Function setTransactionList,
      Function setSnackBar) async {
    if (SearchTransactionValidation.checkTransaction(
        transaction, setSnackBar)) {
      return;
    }

    await Api.getHeader().then((option) async {
      try {
        Response res = await Api.dio.get('$rootURI/getTotalSpending',
            queryParameters: {
              'category_id': transaction.categoryId,
              'sub_category_id': transaction.subCategoryId,
              'start_month': transaction.startMonth,
              'end_month': transaction.endMonth,
            },
            options: option);
        if (res.statusCode != 200) {
          // 失敗
          setSnackBar(res.data['message']);
        } else {
          // 成功
          List<Map<String, dynamic>> resultList = [];
          res.data['category_total_list'].forEach((value) {
            Map<String, dynamic> categoryList = {
              'category_name': value['category_name'],
              'category_total_amount': value['category_total_amount'],
              'sub_category_list': value['sub_category_list']
            };
            resultList.add(categoryList);
          });
          setTransactionList(res.data['total_spending'], resultList);
          if (resultList.isEmpty) {
            setSnackBar('データが存在しませんでした');
          }
        }
      } on DioException catch (e) {
        setSnackBar(Api.errorMessage(e));
      }
    });
  }
}
