import 'package:intl/intl.dart';

class savingTargetClass {
  var userId = '';
  int? savingTargetId;
  var savingTargetName = '';
  num targetAmount = 0;
  num savingTotalAmount = 0;
  num savingCount = 0;
  num monthlyTotalSavingAmount = 0;
  DateTime savingMonth = DateTime.now();

  savingTargetClass();

  savingTargetClass.setFields(
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

  savingTargetClass.setTargetFields(
    this.savingTargetId,
    this.savingTargetName,
  );

  savingTargetClass.setChartFields(
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
    return savingTargetName.isEmpty || targetAmount == 0;
  }

  Map<String, dynamic> getSavingTargetJson() {
    return {
      'userId': userId,
      'savingTargetId': savingTargetId,
      'savingTargetName': savingTargetName,
      'targetAmount': targetAmount
    };
  }

  @override
  String toString() {
    return 'savingTargetClass{userId: $userId, savingTargetId: $savingTargetId, savingTargetName: $savingTargetName, targetAmount: $targetAmount, savingTotalAmount: $savingTotalAmount, savingCount: $savingCount, monthlyTotalSavingAmount: $monthlyTotalSavingAmount, savingMonth: $savingMonth}';
  }
}
