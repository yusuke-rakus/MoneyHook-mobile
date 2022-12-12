class savingTargetClass {
  var userId = '';
  int? savingTargetId;
  var savingTargetName = '';
  int? targetAmount = 0;
  int? savingTotalAmount = 0;
  int? savingCount = 0;
  int? monthlyTotalSavingAmount = 0;
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

  bool hasTargetId() {
    return savingTargetId != null ? true : false;
  }

  @override
  String toString() {
    return 'savingTargetClass{userId: $userId, savingTargetId: $savingTargetId, savingTargetName: $savingTargetName, targetAmount: $targetAmount, savingTotalAmount: $savingTotalAmount, savingCount: $savingCount, monthlyTotalSavingAmount: $monthlyTotalSavingAmount, savingMonth: $savingMonth}';
  }
}
