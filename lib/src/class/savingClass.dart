import 'package:intl/intl.dart';

class savingClass {
  var userId;
  var savingId;
  var savingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var savingName;
  var savingAmount;
  var savingTargetId;
  var savingTargetName;

  savingClass();

  savingClass.setFields(this.savingDate, this.savingName, this.savingId,
      this.savingAmount, this.savingTargetId, this.savingTargetName);

  bool hasSavingId() {
    return savingId.isNotEmpty ? true : false;
  }

  bool hasTargetId() {
    return savingTargetId.isEmpty ? false : true;
  }

  String getDay() {
    return DateFormat('yyyy-MM-dd').parse(savingDate).day.toString();
  }
}
