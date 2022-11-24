import "package:flutter/material.dart";

class VariableAnalysisView extends StatefulWidget {
  const VariableAnalysisView({super.key});

  @override
  State<VariableAnalysisView> createState() => _VariableAnalysis();
}

class _VariableAnalysis extends State<VariableAnalysisView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '変動費分析a',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }
}
