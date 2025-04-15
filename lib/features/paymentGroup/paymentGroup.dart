import 'package:flutter/material.dart';
import 'package:money_hooks/features/paymentGroup/class/groupByPaymentTransaction.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/data/data/transaction/commonTransactionStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/appBarMonth.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/dataNotRegisteredBox.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionApi.dart';
import 'package:money_hooks/features/paymentGroup/data/paymentGroupTransactionLoad.dart';
import 'package:money_hooks/features/paymentGroup/paymentGroupCard.dart';

class PaymentGroupScreen extends StatefulWidget {
  const PaymentGroupScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final EnvClass env;

  @override
  State<PaymentGroupScreen> createState() => _PaymentGroupScreenState();
}

class _PaymentGroupScreenState extends State<PaymentGroupScreen> {
  late EnvClass env;
  late GroupByPaymentTransaction paymentTransactionList =
      GroupByPaymentTransaction();
  late bool _isLoading;
  late bool isCardDefaultOpen = true;

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
    PaymentGroupTransactionLoad.getGroupByPayment(
        env, setLoading, setSnackBar, setGroupByPaymentTransaction);
    Future(() {
      CommonTranTransactionStorage.getIsCardDefaultOpenState()
          .then((activeState) async {
        isCardDefaultOpen = activeState;
      });
    });
  }

  void setReload() {
    PaymentGroupTransactionApi.getGroupByPayment(
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
              PaymentGroupTransactionLoad.getGroupByPayment(
                  env, setLoading, setSnackBar, setGroupByPaymentTransaction);
            },
            addMonth: () {
              env.addMonth();
              PaymentGroupTransactionLoad.getGroupByPayment(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black, fontSize: 20),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                    ? const DataNotRegisteredBox(message: '取引履歴が存在しません')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: paymentTransactionList.paymentList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CenterWidget(
                            child: PaymentGroupCard(
                              payment:
                                  paymentTransactionList.paymentList[index],
                              showTitle: isCardDefaultOpen,
                              env: env,
                              setReload: setReload,
                            ),
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
