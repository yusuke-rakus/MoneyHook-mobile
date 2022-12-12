import 'package:intl/intl.dart';

class savingClass {
  int? savingId;
  var savingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var savingName = '';
  int? savingAmount;
  int? savingTargetId;
  var savingTargetName = '';

  savingClass();

  savingClass.setFields(this.savingDate, this.savingName, var savingId,
      var savingAmount, var savingTargetId, var savingTargetName) {
    this.savingAmount = savingAmount ?? 0;
    this.savingId = savingId ?? 0;
    this.savingTargetId = savingTargetId ?? 0;
    this.savingTargetName = savingTargetName ?? '';
  }

  bool hasSavingId() {
    return savingId != null ? true : false;
  }

  bool hasTargetId() {
    return savingTargetId != null ? false : true;
  }

  String getDay() {
    return DateFormat('yyyy-MM-dd').parse(savingDate).day.toString();
  }
}
