import 'package:intl/intl.dart';

class savingClass {
  var userId;
  int? savingId;
  var savingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var savingName = '';
  num? savingAmount;
  int? savingTargetId;
  var savingTargetName = '';

  savingClass();

  savingClass.setFields(this.savingDate, this.savingName, var savingId,
      this.savingAmount, var savingTargetId, var savingTargetName) {
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

  Map<String, dynamic> getSavingJson() {
    return {
      'userId': userId,
      'savingId': savingId,
      'savingDate': savingDate,
      'savingName': savingName,
      'savingAmount': savingAmount,
      'savingTargetId': savingTargetId
    };
  }

  @override
  String toString() {
    return 'savingClass{savingId: $savingId, savingDate: $savingDate, savingName: $savingName, savingAmount: $savingAmount, savingTargetId: $savingTargetId, savingTargetName: $savingTargetName}';
  }
}
