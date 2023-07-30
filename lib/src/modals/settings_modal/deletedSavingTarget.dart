import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_hooks/src/api/savingTargetApi.dart';
import 'package:money_hooks/src/components/commonLoadingAnimation.dart';
import 'package:money_hooks/src/components/commonLoadingDialog.dart';
import 'package:money_hooks/src/dataLoader/savingTargetLoad.dart';

import '../../class/savingTargetClass.dart';
import '../../components/commonSnackBar.dart';
import '../../components/dataNotRegisteredBox.dart';
import '../../env/envClass.dart';

class DeletedSavingTarget extends StatefulWidget {
  DeletedSavingTarget({Key? key, required this.env}) : super(key: key);
  envClass env;

  @override
  State<DeletedSavingTarget> createState() => _DeletedSavingTarget();
}

class _DeletedSavingTarget extends State<DeletedSavingTarget> {
  late envClass env;
  late List<savingTargetClass> savingTargetList = [];
  late bool _isLoading;

  void setSavingTargetList(List<savingTargetClass> resultList) {
    setState(() {
      savingTargetList = resultList;
    });
  }

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  void reloadList(savingTargetClass savingTarget) {
    setState(() {
      savingTargetList.remove(savingTarget);
    });
  }

  /// 戻す処理
  void _returnSavingTarget(savingTargetClass savingTarget) {
    commonLoadingDialog(context: context);
    SavingTargetApi.returnSavingTarget(
            env, savingTarget, setSnackBar, reloadList)
        .then((value) => Navigator.pop(context));
  }

  /// 削除処理
  void _deleteSavingTargetFromTable(savingTargetClass savingTarget) {
    commonLoadingDialog(context: context);
    SavingTargetApi.deleteSavingTargetFromTable(
            env, savingTarget, setSnackBar, reloadList)
        .then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = true;
    SavingTargetLoad.getDeletedSavingTarget(
            setSavingTargetList, setSnackBar, env.userId)
        .then((value) => setLoading());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (const Text('設定')),
      ),
      body: _isLoading
          ? Center(child: CommonLoadingAnimation.build())
          : Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 10, bottom: 20),
                    height: 55,
                    child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '完了した貯金目標',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                savingTargetList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: savingTargetList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Slidable(
                              key: Key(savingTargetList[index]
                                  .savingTargetId
                                  .toString()),
                              endActionPane: ActionPane(
                                dragDismissible: false,
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (e) => _returnSavingTarget(
                                        savingTargetList[index]),
                                    backgroundColor: Colors.blue,
                                    icon: Icons.refresh_sharp,
                                    label: '戻す',
                                  ),
                                  SlidableAction(
                                    onPressed: (e) =>
                                        _deleteSavingTargetFromTable(
                                            savingTargetList[index]),
                                    backgroundColor: Colors.red,
                                    icon: Icons.delete,
                                    label: '削除',
                                  )
                                ],
                              ),
                              child: ListTile(
                                  title: Text(savingTargetList[index]
                                      .savingTargetName)),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 1,
                            );
                          },
                        ),
                      )
                    : const dataNotRegisteredBox(message: '完了した貯金目標が存在しません'),
              ],
            ),
    );
  }
}
