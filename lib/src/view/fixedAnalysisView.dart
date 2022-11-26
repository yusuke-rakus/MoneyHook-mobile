import "package:flutter/material.dart";

class FixedAnalysisView extends StatefulWidget {
  const FixedAnalysisView({super.key});

  @override
  State<FixedAnalysisView> createState() => _FixedAnalysis();
}

class _FixedAnalysis extends State<FixedAnalysisView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // 月選択
          Container(
            margin: EdgeInsets.only(right: 15, left: 15),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Text('11月', style: TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          // 合計値
          Container(
            margin: EdgeInsets.only(right: 15, left: 15),
            height: 60,
            child: Row(
              children: [
                Text('可処分所得額', style: TextStyle(fontSize: 17)),
                SizedBox(width: 20),
                Text('11,111', style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
