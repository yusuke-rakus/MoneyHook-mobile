import 'package:flutter/cupertino.dart';
import 'package:money_hooks/common/data/data/transaction/commonTransactionStorage.dart';
import 'package:money_hooks/features/settings/class/fontFamily.dart';

class ThemeProvider with ChangeNotifier {
  String _fontFamily = FontFamily.values.first.label;

  String get fontFamily => _fontFamily;

  void setFontFamily(String newFont) {
    _fontFamily = newFont;
    notifyListeners();
  }

  Future<void> initializeFromApi() async {
    _fontFamily = await CommonTranTransactionStorage.getFontFamily();
    notifyListeners();
  }
}
