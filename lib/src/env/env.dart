import 'package:intl/intl.dart';

class envClass {
  var _thisMonth = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1));

  envClass();

  String getMonth() {
    return DateFormat('yyyy-MM-dd').parse(_thisMonth).month.toString();
  }

  // 加算
  void addMonth() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(_thisMonth);
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, 1);

    if (date.compareTo(today) < 0) {
      date = DateTime(date.year, date.month + 1, date.day);
    }

    _thisMonth = DateFormat('yyyy-MM-dd').format(date);
  }

  // 減算
  void subtractMonth() {
    DateTime date = DateFormat('yyyy-MM-dd').parse(_thisMonth);
    date = DateTime(date.year, date.month - 1, date.day);
    _thisMonth = DateFormat('yyyy-MM-dd').format(date);
  }

  get thisMonth => _thisMonth;

  set thisMonth(value) {
    _thisMonth = value;
  }
}
