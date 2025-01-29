import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/icons/QuestionCircleO.dart';
import 'package:money_hooks/icons/Wallet.dart';
import 'package:money_hooks/src/class/response/groupByPaymentTransaction.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/cardWidget.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/editTransaction.dart';

class PaymentGroupCard extends StatefulWidget {
  final Payment payment;
  final bool showTitle;
  final envClass env;
  final Function setReload;

  const PaymentGroupCard(
      {super.key,
      required this.payment,
      required this.showTitle,
      required this.env,
      required this.setReload});

  @override
  State<PaymentGroupCard> createState() => _PaymentGroupCardState();
}

class _PaymentGroupCardState extends State<PaymentGroupCard> {
  late bool showTitle;

  @override
  void initState() {
    super.initState();
    showTitle = widget.showTitle;
  }

  @override
  Widget build(BuildContext context) {
    Payment payment = widget.payment;

    return CardWidget(
      margin: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  showCheckboxColumn: false,
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
                        onSelectChanged: (selected) {
                          if (selected ?? false) {
                            Transaction transaction =
                                payment.transactionList[index];

                            TransactionClass tran =
                                TransactionClass.setTimelineFields(
                                    transaction.transactionId,
                                    DateFormat('yyyy-MM-dd')
                                        .format(transaction.transactionDate),
                                    transaction.transactionAmount.sign,
                                    transaction.transactionAmount.abs(),
                                    transaction.transactionName,
                                    transaction.categoryId,
                                    transaction.categoryName,
                                    transaction.subCategoryId,
                                    transaction.subCategoryName,
                                    transaction.fixedFlg,
                                    payment.paymentId,
                                    payment.paymentName);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditTransaction(
                                      tran, widget.env, widget.setReload),
                                  fullscreenDialog: true),
                            );
                          }
                        },
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
