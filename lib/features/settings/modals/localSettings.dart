import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/common/class/themeProvider.dart';
import 'package:money_hooks/common/data/data/category/commonCategoryStorage.dart';
import 'package:money_hooks/common/data/data/monthlyTransaction/commonMonthlyTransactionStorage.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceLoad.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceStorage.dart';
import 'package:money_hooks/common/data/data/transaction/commonTransactionStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/features/settings/class/fontFamily.dart';
import 'package:money_hooks/features/settings/data/transaction/localSettingsTransactionStorage.dart';
import 'package:provider/provider.dart';

class LocalSettings extends StatefulWidget {
  const LocalSettings({super.key, required this.env});

  final EnvClass env;

  @override
  State<LocalSettings> createState() => _LocalSettingsState();
}

class _LocalSettingsState extends State<LocalSettings> {
  late bool _transactionRecommendState = false;
  late bool _isCardDefaultOpen = false;
  List<PaymentResourceData> paymentResourceList = [];
  PaymentResourceData? _selectedPaymentData;
  List<FontFamily> fontFamilies = FontFamily.values;
  FontFamily fontFamily = FontFamily.values.first;

  @override
  void initState() {
    Future(() async {
      await CommonPaymentResourceLoad.getPaymentResource(
          widget.env, setPaymentResourceList);
      final bool tranRecState =
          await CommonTranTransactionStorage.getTransactionRecommendState();
      final bool cardDefOpenState =
          await CommonTranTransactionStorage.getIsCardDefaultOpenState();
      setState(() {
        _transactionRecommendState = tranRecState;
        _isCardDefaultOpen = cardDefOpenState;
      });

      final String? defPaymentRes =
          await CommonTranTransactionStorage.getDefaultPaymentResource();
      if (defPaymentRes != null) {
        PaymentResourceData selectedPayment = paymentResourceList
            .where((resource) => resource.paymentId == defPaymentRes)
            .toList()
            .first;
        setState(() => _selectedPaymentData = selectedPayment);
      }

      String localFontFamily =
          await CommonTranTransactionStorage.getFontFamily();
      setState(() {
        fontFamily = fontFamilies
            .where((font) => font.label == localFontFamily)
            .toList()
            .first;
      });
    });
    super.initState();
  }

  void _changeRecommendState(bool state) {
    setState(() {
      _transactionRecommendState = state;
      LocalSettingsTransactionStorage.setTransactionRecommendState(state);
    });
  }

  void _changeDefaultPaymentResource(PaymentResourceData selectedPayment) {
    setState(() => _selectedPaymentData = selectedPayment);
    LocalSettingsTransactionStorage.setDefaultPaymentResource(
        selectedPayment.paymentId);
  }

  void _changeIsCardDefaultOpenState(bool state) {
    setState(() {
      _isCardDefaultOpen = state;
      LocalSettingsTransactionStorage.setIsCardDefaultOpenState(state);
    });
  }

  // 支払い方法
  void setPaymentResourceList(List<PaymentResourceData> resultList) {
    if (resultList.isNotEmpty) {
      setState(() {
        for (var value in resultList) {
          paymentResourceList.add(value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientBar(),
          title: (const Text('設定')),
        ),
        body: ListView(
          children: [
            _settingsGroup(context, '収支画面', [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('取引名候補を表示する'),
                  CupertinoSwitch(
                      activeTrackColor: Colors.blue,
                      value: _transactionRecommendState,
                      onChanged: (activeState) =>
                          _changeRecommendState(activeState))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('デフォルトの支払い方法'),
                  DropdownButton(
                    hint: Text("支払方法"),
                    items: [
                      DropdownMenuItem(
                          value: null,
                          child: Text("未選択",
                              style: TextStyle(color: Colors.grey))),
                      ...paymentResourceList.map((resource) => DropdownMenuItem(
                            value: resource.paymentId,
                            child: Text(
                              resource.paymentName,
                            ),
                          )),
                    ],
                    onChanged: (value) {
                      PaymentResourceData selectedPayment = paymentResourceList
                          .where((resource) => resource.paymentId == value)
                          .toList()
                          .first;
                      _changeDefaultPaymentResource(selectedPayment);

                      CommonSnackBar.build(
                          context: context,
                          text: '「${selectedPayment.paymentName}」に設定しました');
                    },
                    value: _selectedPaymentData?.paymentId,
                  )
                ],
              ),
            ]),
            _settingsGroup(context, '支払い方法画面', [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('デフォルトでカードを開ける'),
                  CupertinoSwitch(
                      activeTrackColor: Colors.blue,
                      value: _isCardDefaultOpen,
                      onChanged: (activeState) =>
                          _changeIsCardDefaultOpenState(activeState))
                ],
              ),
            ]),
            _settingsGroup(context, 'ローカル設定', [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('フォント'),
                  DropdownButton(
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily:
                              DefaultTextStyle.of(context).style.fontFamily),
                      focusColor: Colors.transparent,
                      value: fontFamily,
                      items: fontFamilies
                          .map((FontFamily item) => DropdownMenuItem(
                              value: item,
                              child: SizedBox(
                                width: 250,
                                child: Text(
                                  "${item.name} あのイーハトーヴォのすきとおった風",
                                  style: TextStyle(fontFamily: item.label),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              )))
                          .toList(),
                      onChanged: (FontFamily? value) {
                        setState(() async {
                          fontFamily = value!;
                          await LocalSettingsTransactionStorage.setFontFamily(
                              value.label);
                          themeProvider.setFontFamily(fontFamily.label);
                          CommonSnackBar.build(
                              context: context, text: 'フォントを設定しました');
                        });
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('キャッシュを削除する'),
                  TextButton(
                      onPressed: () async {
                        Future(() async {
                          CommonTranTransactionStorage.allDelete();
                          CommonTranTransactionStorage
                              .deleteDefaultPaymentResource();
                          CommonMonthlyTransactionStorage.allDelete();
                          CommonCategoryStorage.allDelete();
                          CommonPaymentResourceStorage.allDelete();
                          setState(() => _selectedPaymentData = null);
                        }).then((value) => CommonSnackBar.build(
                            context: context, text: '削除完了'));
                      },
                      child: Text(
                        '削除',
                        style: TextStyle(color: Colors.black54),
                      )),
                ],
              ),
            ]),
          ],
        ));
  }

  // 設定グループのコンポーネント
  Widget _settingsGroup(BuildContext context, String title, List<Widget> list) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                height: 35,
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: list,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
