import "package:flutter/material.dart";
import 'package:localstore/localstore.dart';
import 'package:money_hooks/src/components/commonSnackBar.dart';
import 'package:money_hooks/src/modals/settings_modal/accountInfo.dart';
import 'package:money_hooks/src/modals/settings_modal/localSettings.dart';
import 'package:money_hooks/src/modals/settings_modal/monthlyTransaction.dart';
import 'package:money_hooks/src/searchStorage/monthlyTransactionStorage.dart';
import 'package:money_hooks/src/searchStorage/savingStorage.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';
import '../env/envClass.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen(this.isLoading, this.env, {super.key});

  bool isLoading;
  envClass env;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("設定"),
        ),
        body: ListView(
          children: [
            _menuCard(context, Icons.account_circle_outlined, 'アカウント情報',
                AccountInfo(env: env)),
            _menuCard(context, Icons.account_tree, '自動入力',
                MonthlyTransaction(env: env)),
            _menuCard(context, Icons.account_circle_outlined, 'ローカル設定',
                const LocalSettings()),
            TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('USER_ID');

                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MyStatefulWidget()));
                },
                child: const Text(
                  'ログアウト',
                  style: TextStyle(color: Colors.black54),
                )),
            TextButton(
                onPressed: () async {
                  final db = Localstore.instance;
                  Future(() async {
                    await db
                        .collection('monthlyTransactionData')
                        .get()
                        .then((value) async {
                      print(value);
                      TransactionStorage.allDelete();
                      SavingStorage.allDelete();
                      MonthlyTransactionStorage.allDelete();
                    });
                  }).then((value) =>
                      CommonSnackBar.build(context: context, text: '削除完了'));
                },
                child: const Text(
                  'デバッグ用キャッシュ全削除',
                  style: TextStyle(color: Colors.black54),
                )),
          ],
        ));
  }

  // カードのコンポーネント
  Widget _menuCard(
      BuildContext context, IconData icons, String title, Widget loadView) {
    return Card(
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => loadView,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icons),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 16)),
                const Expanded(child: SizedBox()),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          )),
    );
  }
}
