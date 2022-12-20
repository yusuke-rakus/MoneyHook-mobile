import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/transactionClass.dart';

class HomeAccordion extends StatelessWidget {
  const HomeAccordion({Key? key, required this.homeTransactionList})
      : super(key: key);
  final List<dynamic> homeTransactionList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      itemCount: homeTransactionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(homeTransactionList[index]['categoryName']),
              Text(transactionClass.formatNum(
                  homeTransactionList[index]['categoryTotalAmount'])),
            ],
          ),
          children: homeTransactionList[index]['subCategoryList']
              .map<Widget>((value) => ListTile(
                      title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(value['subCategoryName']),
                      Text(transactionClass
                          .formatNum(value['subCategoryTotalAmount'])),
                    ],
                  )))
              .toList(),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}
