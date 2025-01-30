import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_hooks/src/class/response/monthlyFixedData.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/editTransaction.dart';

class FixedAnalysisAccordion extends StatelessWidget {
  const FixedAnalysisAccordion(
      {Key? key,
      required this.monthlyFixedList,
      required this.env,
      required this.setReload})
      : super(key: key);
  final List<MFCategoryClass> monthlyFixedList;
  final envClass env;
  final Function setReload;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: monthlyFixedList.length,
      itemBuilder: (BuildContext context, int index) {
        return CenterWidget(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(monthlyFixedList[index].categoryName),
                  Text(
                      '¥${TransactionClass.formatNum(monthlyFixedList[index].totalCategoryAmount.abs())}'),
                ],
              ),
              textColor: Colors.black,
              children: monthlyFixedList[index]
                  .transactionList
                  .map<Widget>((tran) => ListTile(
                          title: InkWell(
                        onTap: () {
                          TransactionClass transaction =
                              TransactionClass.setTimelineFields(
                                  tran.transactionId,
                                  tran.transactionDate,
                                  tran.transactionAmount.toInt(),
                                  tran.transactionAmount.abs(),
                                  tran.transactionName,
                                  monthlyFixedList[index].categoryId,
                                  monthlyFixedList[index].categoryName,
                                  tran.subCategoryId,
                                  tran.subCategoryName,
                                  tran.fixedFlg,
                                  tran.paymentId,
                                  tran.paymentName);
                          print(transaction);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditTransaction(
                                    transaction, env, setReload),
                                fullscreenDialog: true),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                    '${DateFormat('yyyy-MM-dd').parse(tran.transactionDate).day}日')),
                            Expanded(
                                flex: 5, child: Text(tran.transactionName)),
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  Text(
                                      '¥${TransactionClass.formatNum(tran.transactionAmount.abs().toInt())}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )))
                  .toList(),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return CenterWidget(child: const Divider());
      },
    );
  }
}
