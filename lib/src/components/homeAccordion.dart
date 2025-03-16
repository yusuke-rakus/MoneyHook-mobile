import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/dataNotRegisteredBox.dart';
import 'package:money_hooks/src/env/AppTextStyle.dart';

class HomeAccordion extends StatelessWidget {
  const HomeAccordion(
      {Key? key, required this.homeTransactionList, required this.colorList})
      : super(key: key);
  final List<dynamic> homeTransactionList;
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
                              text: homeTransactionList[index]
                                  ['category_name']),
                        ]),
                        style: AppTextStyle.of(context),
                      ),
                      Text(
                        '¥${TransactionClass.formatNum(homeTransactionList[index]['category_total_amount'].abs())}',
                        style: AppTextStyle.of(context),
                      ),
                    ],
                  ),
                  textColor: Colors.black,
                  children: homeTransactionList[index]['sub_category_list']
                      .map<Widget>((value) => ListTile(
                              title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(value['sub_category_name']),
                              Text(
                                  '¥${TransactionClass.formatNum(value['sub_category_total_amount'].abs())}'),
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
        : const dataNotRegisteredBox(message: '取引履歴が存在しません');
  }
}
