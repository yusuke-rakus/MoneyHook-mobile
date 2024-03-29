import 'package:intl/intl.dart';

class SavingTargetClass {
  var userId = '';
  int? savingTargetId;
  var savingTargetName = '';
  num targetAmount = 0;
  num savingTotalAmount = 0;
  num savingCount = 0;
  num monthlyTotalSavingAmount = 0;
  DateTime savingMonth = DateTime.now();
  bool isDisable = false;
  String savingTargetNameError = '';
  String targetAmountError = '';
  int? sortNo;

  SavingTargetClass();

  SavingTargetClass.setFields(
    var this.savingTargetId,
    var this.savingTargetName,
    var targetAmount,
    var savingTotalAmount,
    var savingCount,
  ) {
    this.targetAmount = targetAmount ?? 0;
    this.savingTotalAmount = savingTotalAmount ?? 0;
    this.savingCount = savingCount ?? 0;
  }

  SavingTargetClass.setTargetFields(
    this.savingTargetId,
    this.savingTargetName,
  );

  SavingTargetClass.setChartFields(
    this.monthlyTotalSavingAmount,
    this.savingMonth,
  ) {
    savingTargetId = 0;
  }

  static String formatNum(int num) {
    final formatter = NumberFormat('#,###');
    return formatter.format(num);
  }

  bool hasTargetId() {
    return savingTargetId != null ? true : false;
  }

  bool isDisabled() {
    return savingTargetName.isEmpty || targetAmount == 0 || isDisable;
  }

  Map<String, dynamic> getSavingTargetJson() {
    return {
      'userId': userId,
      'savingTargetId': savingTargetId,
      'savingTargetName': savingTargetName,
      'targetAmount': targetAmount,
    };
  }

  Map<String, dynamic> getSavingAmountForTargetJson() {
    return {
      'savingTargetId': savingTargetId,
      'savingTargetName': savingTargetName,
      'targetAmount': targetAmount,
      'totalSavedAmount': savingTotalAmount,
      'savingCount': savingCount
    };
  }

  Map<String, dynamic> getTotalSavingJson() {
    return {
      'savingMonth': savingMonth.toString(),
      'monthlyTotalSavingAmount': monthlyTotalSavingAmount
    };
  }

  Map<String, dynamic> getSortSavingJson() {
    return {'savingTargetId': savingTargetId, 'sortNo': sortNo};
  }

  @override
  String toString() {
    return 'savingTargetClass{userId: $userId, savingTargetId: $savingTargetId, savingTargetName: $savingTargetName, targetAmount: $targetAmount, savingTotalAmount: $savingTotalAmount, savingCount: $savingCount, monthlyTotalSavingAmount: $monthlyTotalSavingAmount, savingMonth: $savingMonth}';
  }
}
