import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:localstore/localstore.dart';
import 'package:money_hooks/src/components/commonSnackBar.dart';
import 'package:money_hooks/src/modals/settings_modal/accountInfo.dart';
import 'package:money_hooks/src/modals/settings_modal/deletedSavingTarget.dart';
import 'package:money_hooks/src/modals/settings_modal/hideSubCategory.dart';
import 'package:money_hooks/src/modals/settings_modal/localSettings.dart';
import 'package:money_hooks/src/modals/settings_modal/monthlyTransaction.dart';
import 'package:money_hooks/src/searchStorage/categoryStorage.dart';
import 'package:money_hooks/src/searchStorage/monthlyTransactionStorage.dart';
import 'package:money_hooks/src/searchStorage/savingStorage.dart';
import 'package:money_hooks/src/searchStorage/savingTargetStorage.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            _menuCard(context, Icons.account_circle_outlined, 'ローカル設定',
                const LocalSettings()),
            _menuCard(context, Icons.account_tree, '自動入力',
                MonthlyTransaction(env: env)),
            _menuCard(context, Icons.checklist_sharp, 'サブカテゴリの表示',
                HideSubCategory(env: env)),
            _menuCard(context, Icons.savings_outlined, '完了した貯金目標',
                DeletedSavingTarget(env: env)),
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();

                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // サインアウト
                  // prefs
                  //     .remove('USER_ID')
                  //     .then((value) => prefs.remove('TOKEN').then((value) {
                  //           FirebaseAuth.instance.signOut();
                  //           Navigator.pushReplacement(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (BuildContext context) =>
                  //                       const MyStatefulWidget()));
                  //         }));
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
                        .collection('DeletedSavingTargetData')
                        .get()
                        .then((value) async {
                      print(value);
                      TransactionStorage.allDelete();
                      SavingStorage.allDelete();
                      MonthlyTransactionStorage.allDelete();
                      SavingTargetStorage.allDelete();
                      CategoryStorage.allDelete();
                      CategoryStorage.deleteDefaultValue();
                    });
                  }).then((value) =>
                      CommonSnackBar.build(context: context, text: '削除完了'));
                },
                child: const Text(
                  'デバッグ用キャッシュ全削除',
                  style: TextStyle(color: Colors.black54),
                )),
            TextButton(
                onPressed: () {
                  FirebaseAuth.instance
                      .authStateChanges()
                      .listen((User? user) async {
                    if (user == null) {
                      print('Null');
                    } else {
                      // user.getIdToken().then((value) => print(value));

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final userId = prefs.getString('USER_ID');
                      print(userId);
                      print('signed in!');
                    }
                  });
                },
                child: const Text('Firebase確認'))
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
