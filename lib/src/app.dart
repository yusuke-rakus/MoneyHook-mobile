import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/class/screenLabelClass.dart';
import 'package:money_hooks/src/common/env/envClass.dart';
import 'package:money_hooks/src/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/src/features/analysis/analysis.dart';
import 'package:money_hooks/src/features/home/homeScreen.dart';
import 'package:money_hooks/src/features/loading/loading.dart';
import 'package:money_hooks/src/features/login/login.dart';
import 'package:money_hooks/src/features/paymentGroup/paymentGroup.dart';
import 'package:money_hooks/src/features/settings/settings.dart';
import 'package:money_hooks/src/features/timeline/timelineScreen.dart';
import 'package:money_hooks/src/searchStorage/transactionStorage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [Locale('ja')],
      locale: const Locale('ja'),
      title: "MoneyHook",
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        fontFamily: 'MPLUS1p',
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Widget> _screens = [const Loading()];
  int _selectedIndex = 0;
  bool isLogin = false;
  bool isLoading = false;
  late EnvClass env;
  final ScreenLabel homeLabel = ScreenLabel("ホーム", Icons.home_filled);
  final ScreenLabel timelineLabel = ScreenLabel("タイムライン", Icons.show_chart);
  final ScreenLabel analyticsLabel =
      ScreenLabel("費用分析", Icons.pie_chart_outline);
  final ScreenLabel paymentGroupLabel =
      ScreenLabel("支払い方法", Icons.credit_card_outlined);
  final ScreenLabel settingsLabel = ScreenLabel("設定", Icons.settings);

  void setScreenItems() {
    setState(() {
      _screens = [
        HomeScreen(isLoading, env),
        TimelineScreen(isLoading, env),
        AnalysisScreen(isLoading, env),
        PaymentGroupScreen(isLoading, env),
        SettingsScreen(isLoading, env),
      ];
      isLogin = true;
    });
  }

  void setLoginItem() {
    setState(() {
      _screens = [const Login()];
      isLogin = false;
    });
  }

  void setLoadingItem() {
    setState(() {
      _screens = [const Loading()];
      isLogin = false;
    });
  }

  // スナックバー表示[デバッグ用]
  void setSnackBar(String message) {
    CommonSnackBar.build(context: context, text: message);
  }

  @override
  void initState() {
    super.initState();
    // 認証
    Future(() {
      // *** デバッグ用async ***
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        setState(() {
          _selectedIndex = 0;
        });
        if (user == null) {
          // ログイン画面へ
          setLoginItem();
        } else {
          user.getIdToken().then((value) {
            final String? token = value;
            final String? email = user.email;

            if (token != null && email != null) {
              // ローディング画面の表示
              setLoadingItem();
              UserApi.googleSignIn(
                      context, email, token, setSnackBar, setLoginItem)
                  .then((userId) {
                TransactionStorage.allDelete();
                if (userId == null) {
                  setSnackBar('ログインエラーが発生しました');
                  // Googleサインインは成功するも独自サインインに失敗した場合、サインアウト
                  UserApi.signOut();
                  // ログイン画面へ
                  setLoginItem();
                } else {
                  // ホーム画面へ
                  setState(() {
                    env = EnvClass.setUserId(userId);
                  });
                  setScreenItems();
                }
              });
            } else {
              // ログイン画面へ
              setLoginItem();
              FirebaseAuth.instance.signOut();
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: Row(
          children: [
            isLogin && MediaQuery.of(context).size.width > 768
                ? Drawer(
                    width: 250,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 36),
                      children: [
                        _sideBarItem(
                            context, homeLabel.icon, homeLabel.label, 0),
                        _sideBarItem(context, timelineLabel.icon,
                            timelineLabel.label, 1),
                        _sideBarItem(context, analyticsLabel.icon,
                            analyticsLabel.label, 2),
                        _sideBarItem(context, paymentGroupLabel.icon,
                            paymentGroupLabel.label, 3),
                        _sideBarItem(context, settingsLabel.icon,
                            settingsLabel.label, 4),
                      ],
                    ),
                  )
                : const SizedBox(),
            Expanded(child: _screens[_selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: isLogin && MediaQuery.of(context).size.width <= 768
          ? BottomNavigationBar(
              unselectedFontSize: 10,
              selectedFontSize: 10,
              currentIndex: _selectedIndex,
              onTap: isLoading
                  ? null
                  : (int i) {
                      setState(() {
                        _selectedIndex = i;
                      });
                    },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(homeLabel.icon), label: homeLabel.label),
                BottomNavigationBarItem(
                    icon: Icon(timelineLabel.icon), label: timelineLabel.label),
                BottomNavigationBarItem(
                    icon: Icon(analyticsLabel.icon),
                    label: analyticsLabel.label),
                BottomNavigationBarItem(
                    icon: Icon(paymentGroupLabel.icon),
                    label: paymentGroupLabel.label),
                BottomNavigationBarItem(
                    icon: Icon(settingsLabel.icon), label: settingsLabel.label),
              ],
              type: BottomNavigationBarType.fixed,
            )
          : const SizedBox(),
    );
  }

  Widget _sideBarItem(
      BuildContext context, IconData icons, String title, int selectedIndex) {
    return ListTile(
        leading: Icon(icons, color: Colors.blue),
        title: Text(
          title,
          style: const TextStyle(color: Color(0xFF757575)),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = selectedIndex;
          });
        });
  }
}
