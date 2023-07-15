import 'package:money_hooks/src/api/monthlyTransactionApi.dart';
import 'package:money_hooks/src/searchStorage/monthlyTransactionStorage.dart';

import '../env/envClass.dart';

class MonthlyTransactionLoad {
  /// 【収支の自動入力画面】データ
  static void getFixed(envClass env, Function setMonthlyTransactionList,
      Function setLoading, Function setErrorMessage) async {
    MonthlyTransactionStorage.getFixed(env.getUserJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        MonthlyTransactionApi.getFixed(
            env, setMonthlyTransactionList, setLoading, setErrorMessage);
      } else {
        setMonthlyTransactionList(value);
        setLoading();
      }
    });
  }
}
