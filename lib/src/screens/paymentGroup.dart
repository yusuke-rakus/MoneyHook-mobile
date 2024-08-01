import 'package:flutter/material.dart';
import 'package:money_hooks/icons/QuestionCircleO.dart';
import 'package:money_hooks/icons/Wallet.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/class/response/groupByPaymentTransaction.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/appBarMonth.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/components/customFloatingButtonLocation.dart';
import 'package:money_hooks/src/components/dataNotRegisteredBox.dart';
import 'package:money_hooks/src/components/gradientBar.dart';
import 'package:money_hooks/src/dataLoader/transactionLoad.dart';
import 'package:money_hooks/src/env/envClass.dart';

class PaymentGroupScreen extends StatefulWidget {
  const PaymentGroupScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final envClass env;

  @override
  State<PaymentGroupScreen> createState() => _PaymentGroupScreenState();
}

class _PaymentGroupScreenState extends State<PaymentGroupScreen> {
  late envClass env;
  late GroupByPaymentTransaction paymentTransactionList =
      GroupByPaymentTransaction();
  late bool _isLoading;

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  void setGroupByPaymentTransaction(
      int totalSpending,
      int lastMonthTotalSpending,
      double? monthOverMonthSum,
      List<dynamic> paymentList) {
    setState(() => paymentTransactionList = GroupByPaymentTransaction.init(
        totalSpending, lastMonthTotalSpending, monthOverMonthSum, paymentList));
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    env.initMonth();
    _isLoading = widget.isLoading;
    TransactionLoad.getGroupByPayment(
        env, setLoading, setSnackBar, setGroupByPaymentTransaction);
  }

  void setReload() {
    transactionApi.getGroupByPayment(
        env, setLoading, setSnackBar, setGroupByPaymentTransaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientBar(),
        title: CenterWidget(
          child: AppBarMonth(
            subtractMonth: () {
              env.subtractMonth();
              TransactionLoad.getGroupByPayment(
                  env, setLoading, setSnackBar, setGroupByPaymentTransaction);
            },
            addMonth: () {
              env.addMonth();
              TransactionLoad.getGroupByPayment(
                  env, setLoading, setSnackBar, setGroupByPaymentTransaction);
            },
            env: env,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CommonLoadingAnimation.build())
          : ListView(
              children: [
                // 収支
                paymentTransactionList.totalSpending != 0
                    ? CenterWidget(
                        padding: const EdgeInsets.only(top: 18.0, left: 5.0),
                        alignment: Alignment.bottomLeft,
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                              children: [
                                const TextSpan(text: '支出合計'),
                                const WidgetSpan(child: SizedBox(width: 18.0)),
                                TextSpan(
                                    text:
                                        '¥${TransactionClass.formatNum(paymentTransactionList.totalSpending.abs())}')
                              ]),
                        ),
                      )
                    : const SizedBox(),
                paymentTransactionList.monthOverMonthSum != null
                    ? CenterWidget(
                        padding: const EdgeInsets.only(right: 5.0),
                        alignment: Alignment.bottomRight,
                        child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 15.0),
                              children: [
                                const TextSpan(text: '前月: '),
                                TextSpan(
                                    text:
                                        '¥${TransactionClass.formatNum(paymentTransactionList.lastMonthTotalSpending.abs())}'),
                                const TextSpan(text: ' ('),
                                TextSpan(
                                  text:
                                      '${paymentTransactionList.monthOverMonthSum.toString()}%',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: paymentTransactionList
                                                  .totalSpending
                                                  .abs() <=
                                              paymentTransactionList
                                                  .lastMonthTotalSpending
                                                  .abs()
                                          ? const Color(0xFF1B5E20)
                                          : const Color(0xFFB71C1C)),
                                ),
                                const TextSpan(text: ')')
                              ]),
                        ),
                      )
                    : const SizedBox(),
                paymentTransactionList.paymentList.isEmpty
                    ? const dataNotRegisteredBox(message: '取引履歴が存在しません')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paymentTransactionList.paymentList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CenterWidget(
                            child: PaymentGroupCard(
                                payment:
                                    paymentTransactionList.paymentList[index]),
                          );
                        }),
                const SizedBox(
                  height: 90,
                )
              ],
            ),
    );
  }
}

class PaymentGroupCard extends StatefulWidget {
  final Payment payment;

  const PaymentGroupCard({super.key, required this.payment});

  @override
  State<PaymentGroupCard> createState() => _PaymentGroupCardState();
}

class _PaymentGroupCardState extends State<PaymentGroupCard> {
  late bool showTitle;

  @override
  void initState() {
    super.initState();
    showTitle = true;
  }

  @override
  Widget build(BuildContext context) {
    Payment payment = widget.payment;

    return Card(
      margin: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: ListTile(
          title: _titleText(payment.paymentName, payment.paymentAmount,
              payment.paymentTypeId, payment.isPaymentDueLater),
          subtitle: _subTitleText(payment.lastMonthSum, payment.monthOverMonth),
        ),
        initiallyExpanded: showTitle,
        textColor: Colors.black,
        iconColor: Colors.grey,
        onExpansionChanged: (isOpen) {
          setState(() => showTitle = isOpen);
        },
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 50.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  headingRowHeight: 25,
                  dataRowMinHeight: 25,
                  dataRowMaxHeight: 25,
                  columns: [
                    DataColumn(label: _tableText('取引日', isBold: true)),
                    DataColumn(label: _tableText('取引名', isBold: true)),
                    DataColumn(label: _tableText('金額', isBold: true)),
                    DataColumn(label: _tableText('カテゴリ', isBold: true)),
                    DataColumn(label: _tableText('サブカテゴリ', isBold: true)),
                    DataColumn(label: _tableText('固定費', isBold: true)),
                  ],
                  rows: List.generate(
                    payment.transactionList.length,
                    (index) {
                      Transaction tran = payment.transactionList[index];
                      return DataRow(
                        color: WidgetStateProperty.all(index.isEven
                            ? Colors.white
                            : const Color(0xFFF5F5F5)),
                        cells: [
                          DataCell(_tableText('${tran.transactionDate.day}日',
                              fixedFlg: tran.fixedFlg)),
                          DataCell(_tableText(tran.transactionName,
                              fixedFlg: tran.fixedFlg)),
                          DataCell(_tableText(
                              '¥${TransactionClass.formatNum(tran.transactionAmount.abs())}',
                              fixedFlg: tran.fixedFlg)),
                          DataCell(_tableText(tran.categoryName,
                              fixedFlg: tran.fixedFlg)),
                          DataCell(_tableText(
                            tran.subCategoryName,
                            fixedFlg: tran.fixedFlg,
                          )),
                          DataCell(tran.fixedFlg
                              ? const Icon(Icons.check_outlined,
                                  size: 17, color: Color(0xFF616161))
                              : const SizedBox()),
                        ],
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleText(String paymentName, int paymentAmount, int? paymentTypeId,
      bool isPaymentDueLater) {
    Icon getIcon(bool isPaymentDueLater) {
      return isPaymentDueLater
          ? const Icon(Icons.credit_card_outlined)
          : const Icon(Wallet.wallet, size: 20.0);
    }

    return RichText(
      text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 18),
          children: [
            WidgetSpan(
              child: paymentTypeId == null
                  ? const Icon(QuestionCircleO.question_circle_o, size: 20.0)
                  : getIcon(isPaymentDueLater),
              alignment: PlaceholderAlignment.middle,
            ),
            const WidgetSpan(child: SizedBox(width: 10.0)),
            TextSpan(text: paymentName),
            const WidgetSpan(child: SizedBox(width: 10.0)),
            TextSpan(
                text: TransactionClass.formatNum(paymentAmount.abs()),
                style: const TextStyle(color: Color(0xFFB71C1C)))
          ]),
    );
  }

  Widget _subTitleText(int? lastMonthSum, double? monthOverMonth) {
    return lastMonthSum != null && monthOverMonth != null
        ? Row(
            children: [
              const Expanded(child: SizedBox()),
              Tooltip(
                message: '前月合計(前月比)',
                child: Opacity(
                  opacity: 0.75,
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(
                              text: '前月: ', style: TextStyle(fontSize: 13)),
                          TextSpan(
                              text:
                                  '¥${TransactionClass.formatNum(lastMonthSum.abs())}',
                              style: const TextStyle(
                                  fontSize: 16, color: Color(0xFFB71C1C))),
                          const TextSpan(text: ' ('),
                          TextSpan(
                            text: '${monthOverMonth.toString()}%',
                            style: TextStyle(
                                fontSize: 14,
                                color: monthOverMonth <= 0.0
                                    ? const Color(0xFF1B5E20)
                                    : const Color(0xFFB71C1C)),
                          ),
                          const TextSpan(text: ')'),
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: Icon(
                                Icons.info_outline,
                                size: 12,
                              )),
                        ]),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _tableText(String value,
      {bool fixedFlg = false, bool isBold = false}) {
    return Text(
        style: TextStyle(
            fontSize: 14,
            color: fixedFlg ? const Color(0xFF616161) : Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        value);
  }
}
