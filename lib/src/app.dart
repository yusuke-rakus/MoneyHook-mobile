import 'package:flutter/material.dart';
import 'package:money_hooks/src/screens/analysis.dart';
import 'package:money_hooks/src/screens/home.dart';
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
  static const _screens = [
    HomeScreen(),
    TimelineScreen(),
    AnalysisScreen(),
    SavingScreen(),
    SettingsScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedFontSize: 10,
          selectedFontSize: 10,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: "ホーム"),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart), label: "タイムライン"),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline), label: "費用分析"),
            BottomNavigationBarItem(
                icon: Icon(Icons.savings_outlined), label: "貯金"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "設定"),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
