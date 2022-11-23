import "package:flutter/material.dart";
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/modals/editTransaction.dart';

import '../components/monthHeader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MonthHeader(),
      ),
      body: Column(
        children: [
          const Center(
            child: Text(
              "ホーム画面",
              style: TextStyle(fontSize: 32.0),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                print('Hej');
              },
              child: const Text("モーダル")),
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
