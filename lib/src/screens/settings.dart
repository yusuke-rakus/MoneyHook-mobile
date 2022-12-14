import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/modals/settings_modal/accountInfo.dart';
import 'package:money_hooks/src/modals/settings_modal/monthlyTransaction.dart';

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
                const MonthlyTransaction()),
            ElevatedButton(
                onPressed: () async {
                  const storage = FlutterSecureStorage();
                  await storage.deleteAll();

                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MyStatefulWidget()));
                },
                child: const Text('ログアウト')),
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
