import "package:flutter/material.dart";
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/modals/editSaving.dart';
import 'package:money_hooks/src/modals/editSavingTarget.dart';
import 'package:money_hooks/src/view/savingList.dart';
import 'package:money_hooks/src/view/totalSaving.dart';

import '../class/savingTargetClass.dart';

class SavingScreen extends StatelessWidget {
  SavingScreen(this.isLoading, {super.key});

  bool isLoading;

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
              TabBar(tabs: [Tab(text: '貯金一覧'), Tab(text: '貯金総額')])
            ],
          ),
        ),
        body: const TabBarView(children: <Widget>[
          SavingList(),
          TotalSaving(),
        ]),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: Colors.lightBlueAccent,
          children: [
            SpeedDialChild(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditSaving(savingClass()),
                      fullscreenDialog: true),
                );
              },
              child: const Icon(Icons.playlist_add),
              label: '貯金',
              labelStyle: const TextStyle(fontSize: 15),
            ),
            SpeedDialChild(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditSavingTarget(savingTargetClass()),
                      fullscreenDialog: true),
                );
              },
              child: const Icon(Icons.create_new_folder_outlined),
              label: '目標追加',
              labelStyle: const TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
