import 'package:money_hooks/common/data/data/transaction/commonTransactionApi.dart';
import 'package:money_hooks/common/data/data/transaction/commonTransactionStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';

class CommonTranTransactionLoad {
  /// 取引名レコメンド
  static Future<void> getFrequentTransactionName(
      EnvClass env, Function setRecommendList) async {
    await CommonTranTransactionStorage.getTransactionRecommendState()
        .then((activeState) async {
      if (activeState) {
        await CommonTransactionApi.getFrequentTransactionName(
            env, setRecommendList);
      }
    });
  }
}
