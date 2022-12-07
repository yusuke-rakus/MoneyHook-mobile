import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/screens/analysis.dart';
import 'package:money_hooks/src/screens/homeScreen.dart';
import 'package:money_hooks/src/screens/loading.dart';
import 'package:money_hooks/src/screens/login.dart';
import 'package:money_hooks/src/screens/saving.dart';
import 'package:money_hooks/src/screens/settings.dart';
import 'package:money_hooks/src/screens/timelineScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  String? userId;

  FlutterSecureStorage storage = const FlutterSecureStorage();

  void setScreenItems() {
    _screens = [
      HomeScreen(isLoading),
      TimelineScreen(isLoading),
      AnalysisScreen(isLoading),
      SavingScreen(isLoading),
      SettingsScreen(isLoading),
    ];
    isLogin = true;
  }

  void setLoginItem() {
    _screens = [Login(isLoading)];
    isLogin = false;
  }

  @override
  void initState() {
    super.initState();

    // ここで認証
    Future(() async {
      userId = await storage.read(key: 'USER_ID');

      print('UserId: $userId');

      if (userId == null) {
        setState(() {
          setLoginItem();
        });
      } else {
        setState(() {
          setScreenItems();
        });
      }
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
