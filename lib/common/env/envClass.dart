import 'package:intl/intl.dart';

class EnvClass {
  String thisMonth = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var userId;

  EnvClass();

  EnvClass.setUserId(this.userId);

  EnvClass.initNew(this.userId, String month) {
    DateTime date = DateFormat('yyyy-MM-dd').parse(month);
    month = DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month, 1));
    thisMonth = month;
  }

  String getMonth() {
    return DateFormat('yyyy-MM-dd').parse(thisMonth).month.toString();
  }

  DateTime getDateTimeMonth() {
    return DateFormat('yyyy-MM-dd').parse(thisMonth);
  }

  DateTime getLastDayOfMonth() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(thisMonth);
    var beginningNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1));
  }

  // 今月にリセット
  void initMonth() {
    thisMonth = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  }

  // 月設定
  void setMonth(DateTime date) {
    thisMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month, 1));
  }

  // 加算
  void addMonth() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(thisMonth);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, 1);

    if (date.compareTo(today) < 0) {
      date = DateTime(date.year, date.month + 1, date.day);
    }

    thisMonth = DateFormat('yyyy-MM-dd').format(date);
  }

  // 月加算判定
  bool isNotCurrentMonth() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(thisMonth);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, 1);

    return date.compareTo(today) < 0 ? true : false;
  }

  // 減算
  void subtractMonth() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(thisMonth);
    date = DateTime(date.year, date.month - 1, date.day);
    thisMonth = DateFormat('yyyy-MM-dd').format(date);
  }

  Map<String, String> getJson() {
    return {'month': thisMonth};
  }

  Map<String, String> getUserJson() {
    return {'userId': userId};
  }

  static String getToday() {
    return DateFormat('yyyy-MM-dd').format(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  static bool enableFirebaseAuth() {
    return const String.fromEnvironment("ENABLE_FIREBASE_AUTH").isEmpty
        ? true
        : false;
  }

  @override
  String toString() {
    return 'envClass{thisMonth: $thisMonth, userId: $userId}';
  }
}
