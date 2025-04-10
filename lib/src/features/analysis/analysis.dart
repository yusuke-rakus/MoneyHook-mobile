import "package:flutter/material.dart";
import 'package:money_hooks/src/common/widgets/gradientBar.dart';
import 'package:money_hooks/src/common/env/envClass.dart';
import 'package:money_hooks/src/features/analysis/fixedAnalysisView.dart';
import 'package:money_hooks/src/features/analysis/variableAnalysisView.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen(this.isLoading, this.env, {super.key});

  final bool isLoading;
  final EnvClass env;

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
              TabBar(
                tabs: [Tab(text: '月別変動費'), Tab(text: '月別固定費')],
                labelColor: Colors.white,
              )
            ],
          ),
        )),
        body: TabBarView(
          children: <Widget>[
            VariableAnalysisView(env, isLoading),
            FixedAnalysisView(env, isLoading),
          ],
        ),
      ),
    );
  }
}
