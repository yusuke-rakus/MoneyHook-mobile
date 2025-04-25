import 'package:flutter/material.dart';
import 'package:money_hooks/common/class/transactionClass.dart';
import 'package:money_hooks/common/widgets/dataNotRegisteredBox.dart';
import 'package:money_hooks/features/home/class/homeTransaction.dart';

class HomeAccordion extends StatelessWidget {
  const HomeAccordion(
      {super.key, required this.homeTransactionList, required this.colorList});

  final List<Category> homeTransactionList;
  final List<Color> colorList;

  @override
  Widget build(BuildContext context) {
    return homeTransactionList.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            itemCount: homeTransactionList.length,
            itemBuilder: (BuildContext context, int index) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: Icon(
                                Icons.circle,
                                color: colorList[index],
                                size: 10,
                              )),
                          const WidgetSpan(child: SizedBox(width: 7.5)),
                          TextSpan(
                              text: homeTransactionList[index].categoryName),
                        ]),
                      ),
                      Text(
                        '¥${TransactionClass.formatNum(homeTransactionList[index].categoryTotalAmount.abs())}',
                      ),
                    ],
                  ),
                  textColor: Colors.black,
                  children: homeTransactionList[index]
                      .subCategoryList
                      .map<Widget>((value) => ListTile(
                              title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(value.subCategoryName),
                              Text(
                                  '¥${TransactionClass.formatNum(value.subCategoryTotalAmount.abs())}'),
                            ],
                          )))
                      .toList(),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          )
        : const DataNotRegisteredBox(message: '取引履歴が存在しません');
  }
}
