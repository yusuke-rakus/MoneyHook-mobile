import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/components/customFloatingButtonLocation.dart';
import 'package:money_hooks/src/components/gradientBar.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';
import 'package:money_hooks/src/searchStorage/monthlyTransactionStorage.dart';
import 'package:money_hooks/src/searchStorage/paymentResourceStorage.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

class LocalSettings extends StatefulWidget {
  const LocalSettings({super.key});

  @override
  State<LocalSettings> createState() => _LocalSettingsState();
}

class _LocalSettingsState extends State<LocalSettings> {
  late bool _transactionRecommendState = false;
  late bool _isCardDefaultOpen = false;

  @override
  void initState() {
    TransactionStorage.getTransactionRecommendState().then((value) {
      setState(() => _transactionRecommendState = value);
    });
    TransactionStorage.getIsCardDefaultOpenState().then((value) {
      setState(() => _isCardDefaultOpen = value);
    });
    super.initState();
  }

  void _changeRecommendState(bool state) {
    setState(() {
      _transactionRecommendState = state;
      TransactionStorage.setTransactionRecommendState(state);
    });
  }

  void _changeIsCardDefaultOpenState(bool state) {
    setState(() {
      _isCardDefaultOpen = state;
      TransactionStorage.setIsCardDefaultOpenState(state);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('キャッシュを削除する'),
                  TextButton(
                      onPressed: () async {
                        Future(() async {
                          TransactionStorage.allDelete();
                          MonthlyTransactionStorage.allDelete();
                          CategoryStorage.allDelete();
                          PaymentResourceStorage.allDelete();
                        }).then((value) => CommonSnackBar.build(
                            context: context, text: '削除完了'));
                      },
                      child: const Text(
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
