import "package:flutter/material.dart";
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/components/cardWidget.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:money_hooks/src/components/gradientBar.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/modals/settings_modal/hideSubCategory.dart';
import 'package:money_hooks/src/modals/settings_modal/localSettings.dart';
import 'package:money_hooks/src/modals/settings_modal/monthlyTransaction.dart';
import 'package:money_hooks/src/modals/settings_modal/paymentResource.dart';
import 'package:money_hooks/src/modals/settings_modal/searchTransaction.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final envClass env;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientBar(),
          title: const Text("設定"),
        ),
        body: ListView(
          children: [
            _menuCard(context, Icons.account_circle_outlined, 'ローカル設定',
                const LocalSettings()),
            _menuCard(context, Icons.account_tree, '自動入力',
                MonthlyTransaction(env: env)),
            _menuCard(context, Icons.checklist_sharp, 'サブカテゴリの表示',
                HideSubCategory(env: env)),
            _menuCard(context, Icons.search_outlined, '収支の検索',
                SearchTransaction(env: env)),
            _menuCard(context, Icons.account_balance_wallet_outlined, '支払い元の管理',
                PaymentResource(env: env)),
            const SizedBox(
              height: 50,
            ),
            CenterWidget(
              child: TextButton(
                  onPressed: () {
                    UserApi.signOut();
                  },
                  child: const Text(
                    'ログアウト',
                    style: TextStyle(color: Colors.black54),
                  )),
            ),
          ],
        ));
  }

  // カードのコンポーネント
  Widget _menuCard(
      BuildContext context, IconData icons, String title, Widget loadView) {
    return CenterWidget(
      child: CardWidget(
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
                  Text(title, style: TextStyle(fontSize: 16)),
                  const Expanded(child: SizedBox()),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            )),
      ),
    );
  }
}
