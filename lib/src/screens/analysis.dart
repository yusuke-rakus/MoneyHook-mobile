import "package:flutter/material.dart";
import 'package:money_hooks/src/components/gradientBar.dart';
import 'package:money_hooks/src/view/fixedAnalysisView.dart';
import 'package:money_hooks/src/view/variableAnalysisView.dart';

import '../env/envClass.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final envClass env;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            flexibleSpace: GradientBar(
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(tabs: [Tab(text: '月別変動費'), Tab(text: '月別固定費')])
            ],
          ),
        )),
        body: Center(
          child: SizedBox(
            width: 800,
            child: TabBarView(
              children: <Widget>[
                VariableAnalysisView(env, isLoading),
                FixedAnalysisView(env, isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
