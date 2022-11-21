import "package:flutter/material.dart";
import 'package:money_hooks/src/screens/fixedAnalysis.dart';
import 'package:money_hooks/src/screens/variableAnalysis.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(tabs: [Tab(text: '月別変動費'), Tab(text: '月別固定費')]),
            ],
          ),
          // title: const Text('費用分析'),
          // bottom: const TabBar(
          //   tabs: <Widget>[
          //     Tab(text: '月別変動費'),
          //     Tab(text: '月別固定費'),
          //   ],
          // ),
        ),
        body: const TabBarView(
          children: <Widget>[
            VariableAnalysis(),
            FixedAnalysis(),
          ],
        ),
      ),
    );
  }
}
