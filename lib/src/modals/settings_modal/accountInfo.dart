import "package:flutter/material.dart";
import 'package:money_hooks/src/modals/settings_modal/changeEmail.dart';

import 'changePassword.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("設定"),
        ),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                height: 35,
                child: const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'アカウント情報',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
            Flexible(
              child: ListView(
                children: [
                  _menuCard(context, Icons.email_outlined, 'メールアドレス変更',
                      const ChangeEmail()),
                  _menuCard(context, Icons.vpn_key_outlined, 'パスワード変更',
                      const ChangePassword()),
                ],
              ),
            ),
          ],
        ));
  }

  // カードのコンポーネント
  Widget _menuCard(
      BuildContext context, IconData icon, String title, Widget loadView) {
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
                Icon(icon),
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
