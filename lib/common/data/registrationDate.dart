import 'package:money_hooks/common/env/envClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String registrationDate = 'REGISTRATION_DATE';

Future<String?> getRegistrationDate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(registrationDate);
}

Future<void> setRegistrationDate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(registrationDate, EnvClass.getToday());
}

Future<bool> isNeedApi() async {
  String? registrationDate = await getRegistrationDate();
  if (registrationDate == EnvClass.getToday()) {
    return false;
  } else {
    return true;
  }
}

Future<void> removeRegistrationDate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(registrationDate);
}
