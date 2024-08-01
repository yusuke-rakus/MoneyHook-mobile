import 'package:intl/intl.dart';

class Transaction {
  late int transactionId;
  late String transactionName;
  late int transactionAmount;
  late DateTime transactionDate;
  late String categoryName;
  late String subCategoryName;
  late bool fixedFlg;

  Transaction(
      this.transactionId,
      this.transactionName,
      this.transactionAmount,
      this.transactionDate,
      this.categoryName,
      this.subCategoryName,
      this.fixedFlg);

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      map['transaction_id'],
      map['transaction_name'],
      map['transaction_amount'],
      DateFormat('yyyy-MM-dd').parse(map['transaction_date']),
      map['category_name'],
      map['sub_category_name'],
      map['fixed_flg'],
    );
  }
}

class Payment {
  late String paymentName;
  late int paymentAmount;
  late int? paymentTypeId;
  late String paymentTypeName;
  late bool isPaymentDueLater;
  late int? lastMonthSum;
  late double? monthOverMonth;
  late List<Transaction> transactionList;

  Payment(
      this.paymentName,
      this.paymentAmount,
      this.paymentTypeId,
      this.paymentTypeName,
      this.isPaymentDueLater,
      this.lastMonthSum,
      this.monthOverMonth,
      this.transactionList);

  factory Payment.fromMap(Map<String, dynamic> map) {
    List<Transaction> transactions = (map['transaction_list'] as List)
        .map((tran) => Transaction.fromMap(tran))
        .toList();
    return Payment(
      map['payment_name'],
      map['payment_amount'],
      map['payment_type_id'],
      map['payment_type_name'],
      map['is_payment_due_later'],
      map['last_month_sum'],
      map['month_over_month'],
      transactions,
    );
  }
}

class GroupByPaymentTransaction {
  late int totalSpending = 0;
  late int lastMonthTotalSpending = 0;
  late double? monthOverMonthSum = null;
  late List<Payment> paymentList = [];

  GroupByPaymentTransaction.init(
      this.totalSpending,
      this.lastMonthTotalSpending,
      this.monthOverMonthSum,
      List<dynamic> paymentList) {
    this.paymentList =
        paymentList.map((payment) => Payment.fromMap(payment)).toList();
  }

  GroupByPaymentTransaction();

  GroupByPaymentTransaction.setResponse(this.totalSpending,
      this.lastMonthTotalSpending, this.monthOverMonthSum, this.paymentList);

  @override
  String toString() {
    return 'GroupByPaymentTransaction{totalSpending: $totalSpending, paymentList: $paymentList}';
  }
}
