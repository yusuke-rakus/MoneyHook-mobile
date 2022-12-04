import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class envClass {
  String thisMonth = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1));

  envClass();

  String getMonth() {
    return DateFormat('yyyy-MM-dd').parse(thisMonth).month.toString();
  }

  // 加算
  Future<void> addMonth() async {
    DateTime date = DateFormat('yyyy-MM-dd').parse(thisMonth);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, 1);

    if (date.compareTo(today) < 0) {
      date = DateTime(date.year, date.month + 1, date.day);
    }

    thisMonth = DateFormat('yyyy-MM-dd').format(date);

    //ここから試験用
    // const storage = FlutterSecureStorage();
    // String? userId = await storage.read(key: 'USER_ID');
    // print('ユーザーID: ${userId == null}');
    // print('ユーザーID: $userId');
  }

  // 減算
  void subtractMonth() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(thisMonth);
    date = DateTime(date.year, date.month - 1, date.day);
    thisMonth = DateFormat('yyyy-MM-dd').format(date);

    //ここから試験用
    // const storage = FlutterSecureStorage();
    // storage.write(key: 'USER_ID', value: 'Hej,sampleValue');
    // storage.deleteAll();
  }
}
