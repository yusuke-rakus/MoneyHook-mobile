import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/class/screenLabelClass.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/screens/analysis.dart';
import 'package:money_hooks/src/screens/homeScreen.dart';
import 'package:money_hooks/src/screens/loading.dart';
import 'package:money_hooks/src/screens/login.dart';
import 'package:money_hooks/src/screens/settings.dart';
import 'package:money_hooks/src/screens/timelineScreen.dart';

import 'components/commonSnackBar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
      ],
      locale: const Locale('ja'),
      title: "MoneyHook",
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.mPlus1pTextTheme(),
        primaryTextTheme: GoogleFonts.mPlus1pTextTheme(),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle:
              GoogleFonts.mPlus1p(fontSize: 16.0, color: Colors.white),
        ),
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Widget> _screens = [const Loading()];
  int _selectedIndex = 0;
  bool isLogin = false;
  bool isLoading = false;
  late envClass env;
  final ScreenLabel homeLabel = ScreenLabel("ホーム", Icons.home_filled);
  final ScreenLabel timelineLabel = ScreenLabel("タイムライン", Icons.show_chart);
  final ScreenLabel analyticsLabel =
      ScreenLabel("費用分析", Icons.pie_chart_outline);
  final ScreenLabel settingsLabel = ScreenLabel("設定", Icons.settings);

  void setScreenItems() {
    setState(() {
      _screens = [
        HomeScreen(isLoading, env),
        TimelineScreen(isLoading, env),
        AnalysisScreen(isLoading, env),
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
                if (userId == null) {
                  setSnackBar('ログインエラーが発生しました');
                  // Googleサインインは成功するも独自サインインに失敗した場合、サインアウト
                  UserApi.signOut();
                  // ログイン画面へ
                  setLoginItem();
                } else {
                  // ホーム画面へ
                  setState(() {
                    env = envClass.setUserId(userId);
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
      body: Row(
        children: [
          isLogin && MediaQuery.of(context).size.width > 768
              ? Drawer(
                  width: 250,
                  // backgroundColor: Colors.white,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 36),
                    children: [
                      _sideBarItem(context, homeLabel.icon, homeLabel.label, 0),
                      _sideBarItem(
                          context, timelineLabel.icon, timelineLabel.label, 1),
                      _sideBarItem(context, analyticsLabel.icon,
                          analyticsLabel.label, 2),
                      _sideBarItem(
                          context, settingsLabel.icon, settingsLabel.label, 3),
                    ],
                  ),
                )
              : const SizedBox(),
          Expanded(child: _screens[_selectedIndex]),
        ],
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
        leading: Icon(icons, color: Colors.lightBlueAccent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = selectedIndex;
          });
        });
  }
}
