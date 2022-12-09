class savingTargetClass {
  var userId;
  var savingTargetId;
  var savingTargetName;
  var targetAmount;
  var savingTotalAmount;
  var savingCount;
  var monthlyTotalSavingAmount;
  var savingMonth;

  savingTargetClass();

  savingTargetClass.setFields(
    var savingTargetId,
    var savingTargetName,
    var targetAmount,
    var savingTotalAmount,
    var savingCount,
  ) {
    this.savingTargetId = savingTargetId;
    this.savingTargetName = savingTargetName;
    this.targetAmount = targetAmount == null ? 0 : targetAmount;
    this.savingTotalAmount = savingTotalAmount == null ? 0 : savingTotalAmount;
    this.savingCount = savingCount == null ? 0 : savingCount;
  }

  savingTargetClass.setTargetFields(
    this.savingTargetId,
    this.savingTargetName,
  );

  savingTargetClass.setChartFields(
    this.monthlyTotalSavingAmount,
    this.savingMonth,
  );

  bool hasTargetId() {
    return savingTargetId.isNotEmpty ? true : false;
  }

  @override
  String toString() {
    return 'savingTargetClass{userId: $userId, savingTargetId: $savingTargetId, savingTargetName: $savingTargetName, targetAmount: $targetAmount, savingTotalAmount: $savingTotalAmount, savingCount: $savingCount, monthlyTotalSavingAmount: $monthlyTotalSavingAmount, savingMonth: $savingMonth}';
  }
}
