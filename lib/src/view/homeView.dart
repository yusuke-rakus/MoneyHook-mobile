import 'package:flutter/material.dart';
import 'package:money_hooks/src/components/homeAccodion.dart';

import '../class/transactionClass.dart';
import '../env/env.dart';
import '../modals/editTransaction.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late envClass env;
  late List<transactionClass> timelineList;

  @override
  void initState() {
    super.initState();
    env = envClass();
    timelineList = [
      transactionClass.setTimelineFields(
          '1', '2022-11-01', -1, '1000', 'スーパーアルプス1', '食費'),
      transactionClass.setTimelineFields(
          '2', '2022-11-01', -1, '1000', 'スーパーアルプス2', '食費'),
      transactionClass.setTimelineFields(
          '3', '2022-11-01', -1, '1000', 'スーパーアルプス3', '食費'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    env.subtractMonth();
                    timelineList.clear();
                  });
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Text('${env.getMonth()}月'),
            IconButton(
                onPressed: () {
                  setState(() {
                    env.addMonth();
                  });
                },
                icon: const Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 10, right: 8, left: 8),
              color: Colors.cyan,
              height: 180,
              width: double.infinity,
              child: const Center(child: Text('Hej!'))),
          Container(
            margin: const EdgeInsets.only(left: 8),
            height: 40,
            child: Row(
              children: const [
                Text('収支', style: TextStyle(fontSize: 20)),
                SizedBox(width: 20),
                Text('-12000',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
              ],
            ),
          ),
          const HomeAccodion()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditTransaction(transactionClass()),
                fullscreenDialog: true),
          );
        },
      ),
    );
  }
}
