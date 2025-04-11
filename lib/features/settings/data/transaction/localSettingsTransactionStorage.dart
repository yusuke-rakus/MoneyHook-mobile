import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsTransactionStorage {
  static final db = Localstore.instance;

  /// 取引名レコメンド
  static void setTransactionRecommendState(bool activeState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_TRANSACTION_RECOMMEND_ACTIVE', activeState);
  }

  /// デフォルトでカードを開けた他状態にするかどうか
  static void setIsCardDefaultOpenState(bool activeState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_CARD_DEFAULT_OPEN', activeState);
  }
}
