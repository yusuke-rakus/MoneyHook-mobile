import 'package:intl/intl.dart';

class savingClass {
  var userId;
  int? savingId;
  var savingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var savingName = '';
  num savingAmount = 0;
  num? savingTargetId;
  var savingTargetName = '';
  String savingNameError = '';
  String savingAmountError = '';

  savingClass();

  savingClass.setFields(this.savingDate, this.savingName, var savingId,
      this.savingAmount, this.savingTargetId, var savingTargetName) {
    this.savingId = savingId ?? 0;
    this.savingTargetName = savingTargetName ?? '';
  }

  static String formatNum(int num) {
    final formatter = NumberFormat('#,###');
    return formatter.format(num);
  }

  static int formatInt(String v) {
    return int.parse(v.replaceAll(',', ''));
  }

  bool hasSavingId() {
    return savingId != null ? true : false;
  }

  bool isDisabled() {
    return savingName.isEmpty || savingAmount == 0;
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
