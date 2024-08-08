import 'package:flutter/material.dart';
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
import 'package:money_hooks/src/organisms/paymentGroup/paymentGroupCard.dart';

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
    // env.initMonth();
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
