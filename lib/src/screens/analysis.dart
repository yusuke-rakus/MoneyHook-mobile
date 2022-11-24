import "package:flutter/material.dart";
import 'package:money_hooks/src/view/fixedAnalysisView.dart';
import 'package:money_hooks/src/view/variableAnalysisView.dart';

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
        ),
        body: const TabBarView(
          children: <Widget>[
            VariableAnalysisView(),
            FixedAnalysisView(),
          ],
        ),
      ),
    );
  }
}
