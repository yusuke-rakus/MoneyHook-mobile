import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:money_hooks/src/api/userApi.dart';
import 'package:money_hooks/src/env/envClass.dart';
import 'package:money_hooks/src/screens/analysis.dart';
import 'package:money_hooks/src/screens/homeScreen.dart';
import 'package:money_hooks/src/screens/loading.dart';
import 'package:money_hooks/src/screens/login.dart';
import 'package:money_hooks/src/screens/saving.dart';
import 'package:money_hooks/src/screens/settings.dart';
import 'package:money_hooks/src/screens/timelineScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        primarySwatch: Colors.blue,
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

  void setScreenItems() {
    _screens = [
      HomeScreen(isLoading, env),
      TimelineScreen(isLoading, env),
      AnalysisScreen(isLoading, env),
      SavingScreen(isLoading, env),
      SettingsScreen(isLoading, env),
    ];
    isLogin = true;
  }

  void setLoginItem() {
    _screens = [Login(isLoading)];
    isLogin = false;
  }

  void setLoadingItem() {
    _screens = [const Loading()];
    isLogin = false;
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
          // *** デバッグ用ログイン start ***
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final userId = prefs.getString('USER_ID');
          if (userId != null) {
            setState(() {
              env = envClass.setUserId(userId);
              setScreenItems();
            });
          }
          // *** デバッグ用ログイン end ***
          else {
            // ログイン画面へ
            setState(() {
              setLoginItem();
            });
          }
        } else {
          user.getIdToken().then((value) {
            final String? token = value;
            final String? email = user.email;

            if (token != null && email != null) {
              // ローディング画面の表示
              setLoadingItem();
              userApi.googleSignIn(context, email, token).then((userId) {
                if (userId == null) {
                  // Googleサインインは成功するも独自サインインに失敗した場合、サインアウト
                  FirebaseAuth.instance.signOut();
                  // ログイン画面へ
                  setState(() {
                    setLoginItem();
                  });
                } else {
                  // ホーム画面へ
                  setState(() {
                    env = envClass.setUserId(userId);
                    setScreenItems();
                  });
                }
              });
            } else {
              // ログイン画面へ
              setState(() {
                setLoginItem();
              });
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: isLogin
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
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: "ホーム"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.show_chart), label: "タイムライン"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart_outline), label: "費用分析"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.savings_outlined), label: "貯金"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "設定"),
              ],
              type: BottomNavigationBarType.fixed,
            )
          : const SizedBox(),
    );
  }
}
