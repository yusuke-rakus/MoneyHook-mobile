import "package:flutter/material.dart";
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money_hooks/src/class/savingClass.dart';
import 'package:money_hooks/src/modals/editSaving.dart';
import 'package:money_hooks/src/modals/editSavingTarget.dart';
import 'package:money_hooks/src/view/savingList.dart';
import 'package:money_hooks/src/view/totalSaving.dart';

import '../class/savingTargetClass.dart';
import '../env/envClass.dart';

class SavingScreen extends StatefulWidget {
  SavingScreen(this.isLoading, this.env, {super.key});

  bool isLoading;
  envClass env;

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  late Function setReload;

  void changeReload(Function function) {
    setReload = function;
  }

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
        body: TabBarView(children: <Widget>[
          SavingList(widget.env, changeReload),
          TotalSaving(widget.env, changeReload),
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
                      builder: (context) =>
                          EditSaving(savingClass(), widget.env, setReload),
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
                      builder: (context) => EditSavingTarget(
                          savingTargetClass(), widget.env, setReload),
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
