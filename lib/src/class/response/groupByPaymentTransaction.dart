class Transaction {
  late int transactionId;
  late String transactionName;
  late int transactionAmount;
  late String categoryName;
  late String subCategoryName;
  late bool fixedFlg;

  Transaction(this.transactionId, this.transactionName, this.transactionAmount,
      this.categoryName, this.subCategoryName, this.fixedFlg);

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      map['transaction_id'],
      map['transaction_name'],
      map['transaction_amount'],
      map['category_name'],
      map['sub_category_name'],
      map['fixed_flg'],
    );
  }
}

class Payment {
  late String paymentName;
  late int paymentAmount;
  late int? lastMonthSum;
  late double? monthOverMonth;
  late List<Transaction> transactionList;

  Payment(this.paymentName, this.paymentAmount, this.lastMonthSum,
      this.monthOverMonth, this.transactionList);

  factory Payment.fromMap(Map<String, dynamic> map) {
    List<Transaction> transactions = (map['transaction_list'] as List)
        .map((tran) => Transaction.fromMap(tran))
        .toList();
    return Payment(
      map['payment_name'],
      map['payment_amount'],
      map['last_month_sum'],
      map['month_over_month'],
      transactions,
    );
  }
}

class GroupByPaymentTransaction {
  late int totalSpending = 0;
  late List<Payment> paymentList = [];

  GroupByPaymentTransaction.init(
      this.totalSpending, List<dynamic> paymentList) {
    this.paymentList =
        paymentList.map((payment) => Payment.fromMap(payment)).toList();
  }

  GroupByPaymentTransaction();

  GroupByPaymentTransaction.setResponse(this.totalSpending, this.paymentList);

  @override
  String toString() {
    return 'GroupByPaymentTransaction{totalSpending: $totalSpending, paymentList: $paymentList}';
  }
}
