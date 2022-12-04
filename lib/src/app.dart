import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_hooks/src/screens/analysis.dart';
import 'package:money_hooks/src/screens/home.dart';
import 'package:money_hooks/src/screens/loading.dart';
import 'package:money_hooks/src/screens/login.dart';
import 'package:money_hooks/src/screens/saving.dart';
import 'package:money_hooks/src/screens/settings.dart';
import 'package:money_hooks/src/screens/timeline.dart';

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
  late Widget _bottomNavigationBar = const SizedBox();

  FlutterSecureStorage storage = const FlutterSecureStorage();
  String? userId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void setScreenItems() {
    _screens = [
      const HomeScreen(),
      const TimelineScreen(),
      const AnalysisScreen(),
      const SavingScreen(),
      const SettingsScreen(),
    ];
    _bottomNavigationBar = BottomNavigationBar(
      unselectedFontSize: 10,
      selectedFontSize: 10,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "ホーム"),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "タイムライン"),
        BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline), label: "費用分析"),
        BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined), label: "貯金"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "設定"),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }

  void setLoginItem() {
    _screens = [Login()];
    _bottomNavigationBar = const SizedBox();
  }

  @override
  void initState() {
    super.initState();

    // ここで認証
    Future(() async {
      userId = await storage.read(key: 'USER_ID');

      if (userId == null) {
        print('Loaded: $userId');
        setState(() {
          setLoginItem();
        });
      } else {
        print('Reloaded: $userId');
        setState(() {
          setScreenItems();
        });
      }
      print('finished1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: _bottomNavigationBar);
  }
}
