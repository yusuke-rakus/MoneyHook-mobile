import 'package:money_hooks/common/data/registrationDate.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/home/data/homeTransactionApi.dart';
import 'package:money_hooks/features/home/data/homeTransactionStorage.dart';

class HomeTransactionLoad {
  /// 【ホーム画面】データ
  static Future<void> getHome(EnvClass env, Function setLoading,
      Function setSnackBar, Function setHomeTransaction) async {
    Map<String, dynamic> value =
        await HomeTransactionStorage.getHome(env.getJson().toString());

    if (value.isEmpty || await isNeedApi()) {
      await HomeTransactionApi.getHome(
          env, setLoading, setSnackBar, setHomeTransaction);
      await setRegistrationDate();
    } else {
      setHomeTransaction(value['balance'], value['category_list']);
    }
  }
}
