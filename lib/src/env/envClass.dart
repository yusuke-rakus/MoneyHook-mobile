import 'package:intl/intl.dart';

class envClass {
  String thisMonth = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var userId;

  envClass();

  envClass.setUserId(this.userId);

  String getMonth() {
    return DateFormat('yyyy-MM-dd').parse(thisMonth).month.toString();
  }

  // 今月にリセット
  void initMonth() {
    thisMonth = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  }

  // 加算
  Future<void> addMonth() async {
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
    return {'month': thisMonth, 'userId': userId};
  }

  @override
  String toString() {
    return 'envClass{thisMonth: $thisMonth, userId: $userId}';
  }
}
