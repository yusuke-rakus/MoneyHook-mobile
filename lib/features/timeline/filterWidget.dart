import 'package:flutter/material.dart';
import 'package:money_hooks/common/class/categoryClass.dart';
import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceLoad.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonLoadingAnimation.dart';
import 'package:money_hooks/common/widgets/gradientButton.dart';
import 'package:money_hooks/features/editTransaction/data/category/editTranCategoryLoad.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget(
      {super.key,
      required this.env,
      required this.receivedFilterCategories,
      required this.receivedFilterPayments});

  final EnvClass env;
  final List<CategoryClass> receivedFilterCategories;
  final List<PaymentResourceData> receivedFilterPayments;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  List<CategoryClass> categoryList = [];
  List<PaymentResourceData> payments = [];
  List<CategoryClass> filterCategories = [];
  List<PaymentResourceData> filterPayments = [];

  Future<void> setCategoryList(List<CategoryClass> responseList) async {
    setState(() => categoryList = responseList);
  }

  void setPaymentResourceList(List<PaymentResourceData> resultList) {
    setState(() => payments = resultList);
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await EditTranCategoryLoad.getCategoryList(setCategoryList);
      await CommonPaymentResourceLoad.getPaymentResource(
          widget.env, setPaymentResourceList);
      setState(() {
        if (widget.receivedFilterCategories.isNotEmpty) {
          filterCategories = widget.receivedFilterCategories;
        }
        if (widget.receivedFilterPayments.isNotEmpty) {
          filterPayments = widget.receivedFilterPayments;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          '絞り込み',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('カテゴリ'),
                      Visibility(
                        visible: filterCategories.isNotEmpty,
                        child: TextButton(
                            onPressed: () {
                              setState(() => filterCategories = []);
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.grey),
                            child: Text("リセット")),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                    ),
                    child: categoryList.isEmpty
                        ? CenterWidget(child: CommonLoadingAnimation.build())
                        : ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                children:
                                    categoryList.map((CategoryClass category) {
                                  return FilterChip(
                                      label: Text(category.categoryName),
                                      selected:
                                          filterCategories.contains(category),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            filterCategories.add(category);
                                          } else {
                                            filterCategories.remove(category);
                                          }
                                        });
                                      });
                                }).toList(),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 10.0),
                  Visibility(
                    visible: payments.isNotEmpty,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('支払い方法'),
                        Visibility(
                          visible: filterPayments.isNotEmpty,
                          child: TextButton(
                              onPressed: () {
                                setState(() => filterPayments = []);
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey),
                              child: Text("リセット")),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: payments.isNotEmpty,
                    child: Container(
                      margin: EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 5.0,
                            runSpacing: 5.0,
                            children: payments.map((payment) {
                              return FilterChip(
                                  label: Text(payment.paymentName),
                                  selected: filterPayments.contains(payment),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        filterPayments.add(payment);
                                      } else {
                                        filterPayments.remove(payment);
                                      }
                                    });
                                  });
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }),
        ),
        actions: [
          GradientButton(
            onPressed: () {
              Navigator.pop(context, {
                'filterCategories': filterCategories,
                'filterPayments': filterPayments
              });
            },
            borderRadius: 0,
            child: Text("適用"),
          ),
        ]);
  }
}
