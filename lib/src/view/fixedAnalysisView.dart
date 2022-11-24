import "package:flutter/material.dart";

class FixedAnalysisView extends StatefulWidget {
  const FixedAnalysisView({super.key});

  @override
  State<FixedAnalysisView> createState() => _FixedAnalysis();
}

class _FixedAnalysis extends State<FixedAnalysisView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '固定費分析',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
    );
  }
}
