import "package:flutter/material.dart";
import 'package:money_hooks/src/components/fixedAnalysisAccodion.dart';

class FixedAnalysisView extends StatefulWidget {
  const FixedAnalysisView({super.key});

  @override
  State<FixedAnalysisView> createState() => _FixedAnalysis();
}

class _FixedAnalysis extends State<FixedAnalysisView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 月選択
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const Text('11月', style: TextStyle(fontSize: 15)),
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          Flexible(
              child: ListView(
            children: [
              // 合計値
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15),
                height: 60,
                child: Row(
                  children: const [
                    Text('可処分所得額', style: TextStyle(fontSize: 17)),
                    SizedBox(width: 20),
                    Text('11,112', style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
              // 収入
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    color: Colors.white,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '収入',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '¥10,000',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: const FixedAnalysisAccordion(),
                  )
                ],
              ),
              const SizedBox(height: 30),
              // 支出
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    color: Colors.white,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '支出',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '¥10,000',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  const FixedAnalysisAccordion()
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
