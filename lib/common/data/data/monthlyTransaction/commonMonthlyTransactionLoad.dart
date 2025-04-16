import 'package:money_hooks/common/data/data/monthlyTransaction/commonMonthlyTransactionApi.dart';
import 'package:money_hooks/common/data/data/monthlyTransaction/commonMonthlyTransactionStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';

class CommonMonthlyTransactionLoad {
  /// 【収支の自動入力画面】データ
  static Future<void> getFixed(EnvClass env, Function setMonthlyTransactionList,
      Function setLoading, Function setErrorMessage) async {
    await CommonMonthlyTransactionStorage.getFixed(env.getUserJson().toString())
        .then((value) async {
      if (value.isEmpty) {
        await CommonMonthlyTransactionApi.getFixed(
            env, setMonthlyTransactionList, setLoading, setErrorMessage);
      } else {
        setMonthlyTransactionList(value);
        setLoading();
      }
    });
  }
}
