import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/transactionApi.dart';
import 'package:money_hooks/src/dataLoader/transactionLoad.dart';

import '../class/response/groupByPaymentTransaction.dart';
import '../class/transactionClass.dart';
import '../components/centerWidget.dart';
import '../components/commonLoadingAnimation.dart';
import '../components/customFloatingButtonLocation.dart';
import '../components/gradientBar.dart';
import '../env/envClass.dart';

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
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  // メッセージの設定
  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  void setGroupByPaymentTransaction(
      int totalSpending, List<dynamic> paymentList) {
    setState(() {
      paymentTransactionList =
          GroupByPaymentTransaction.init(totalSpending, paymentList);
    });
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Tooltip(
                message: "前の月",
                child: IconButton(
                    onPressed: () {
                      env.subtractMonth();
                      TransactionLoad.getGroupByPayment(env, setLoading,
                          setSnackBar, setGroupByPaymentTransaction);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
              ),
              Text('${env.getMonth()}月'),
              Tooltip(
                message: "次の月",
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        // 翌月が未来でなければデータ取得
                        if (env.isNotCurrentMonth()) {
                          env.addMonth();
                          TransactionLoad.getGroupByPayment(env, setLoading,
                              setSnackBar, setGroupByPaymentTransaction);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CommonLoadingAnimation.build())
          : ListView(
              children: [
                // 収支
                CenterWidget(
                  height: 40,
                  margin: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      const Text('支出合計', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 20),
                      Text(
                          TransactionClass.formatNum(
                              paymentTransactionList.totalSpending),
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xFFB71C1C))),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentTransactionList.paymentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CenterWidget(
                        child: PaymentGroupCard(
                            payment: paymentTransactionList.paymentList[index]),
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
    return Card(
      margin: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: !showTitle
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Icon(Icons.credit_card_outlined),
                    const SizedBox(width: 10),
                    Text(widget.payment.paymentName),
                    const SizedBox(width: 10),
                    Text(
                        TransactionClass.formatNum(
                            widget.payment.paymentAmount.abs()),
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFFB71C1C)))
                  ],
                ),
              )
            : const SizedBox(),
        initiallyExpanded: showTitle,
        textColor: Colors.black,
        iconColor: Colors.grey,
        onExpansionChanged: (isOpen) {
          setState(() => showTitle = isOpen);
        },
        children: [
          ListTile(
            leading: const Icon(Icons.credit_card_outlined),
            title: Row(
              children: [
                Text(widget.payment.paymentName,
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 15),
                Text(
                    TransactionClass.formatNum(
                        widget.payment.paymentAmount.abs()),
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFFB71C1C)))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  headingRowHeight: 25,
                  dataRowMinHeight: 25,
                  dataRowMaxHeight: 25,
                  columns: [
                    DataColumn(label: _tableText("取引名", isBold: true)),
                    DataColumn(label: _tableText("金額", isBold: true)),
                    DataColumn(label: _tableText("カテゴリ", isBold: true)),
                    DataColumn(label: _tableText("サブカテゴリ", isBold: true)),
                    DataColumn(label: _tableText("固定費", isBold: true)),
                  ],
                  rows: List.generate(
                    widget.payment.transactionList.length,
                    (index) {
                      Transaction tran = widget.payment.transactionList[index];
                      return DataRow(
                        color: WidgetStateProperty.all(index.isEven
                            ? Colors.white
                            : const Color(0xFFF5F5F5)),
                        cells: [
                          DataCell(_tableText(tran.transactionName,
                              fixedFlg: tran.fixedFlg)),
                          DataCell(_tableText(
                              TransactionClass.formatNum(
                                  tran.transactionAmount),
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
