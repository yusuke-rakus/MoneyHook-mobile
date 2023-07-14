import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/components/commonSnackBar.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

class LocalSettings extends StatefulWidget {
  const LocalSettings({super.key});

  @override
  State<LocalSettings> createState() => _LocalSettingsState();
}

class _LocalSettingsState extends State<LocalSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: (const Text('設定')),
        ),
        body: Column(
          children: [
            _settingsGroup(context, '収支画面', [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('取引名候補を表示する'),
                  CupertinoSwitch(
                      value: true,
                      onChanged: (bool value) {
                        value = !value;
                      })
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
                          transactionStorage.deleteTimelineData();
                          transactionStorage.deleteTimelineChart();
                          transactionStorage.deleteHomeData();
                        }).then((value) => CommonSnackBar.build(
                            context: context, text: '削除完了'));
                      },
                      child: const Text(
                        '削除',
                        style: TextStyle(color: Colors.black54),
                      )),
                ],
              ),
            ])
          ],
        ));
  }

  // 設定グループのコンポーネント
  Widget _settingsGroup(BuildContext context, String title, List<Widget> list) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(left: 10),
            height: 35,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            shrinkWrap: true,
            children: list,
          ),
        ),
      ],
    );
  }
}
