import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsTransactionStorage {
  static final db = Localstore.instance;

  /// 取引名レコメンド
  static void setTransactionRecommendState(bool activeState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_TRANSACTION_RECOMMEND_ACTIVE', activeState);
  }

  /// 自動補完
  static void setIsSmartEntryEnabled(bool activeState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_SMART_ENTRY_ENABLED', activeState);
  }

  /// デフォルトの支払い方法
  static void setDefaultPaymentResource(String? paymentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'DEFAULT_PAYMENT_RESOURCE';
    if (paymentId != null) {
      prefs.setString(key, paymentId);
    } else {
      prefs.remove(key);
    }
  }

  /// デフォルトでカードを開けた他状態にするかどうか
  static void setIsCardDefaultOpenState(bool activeState) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('IS_CARD_DEFAULT_OPEN', activeState);
  }

  /// フォントファミリー
  static Future<void> setFontFamily(String fontFamily) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FONT_FAMILY', fontFamily);
  }
}
