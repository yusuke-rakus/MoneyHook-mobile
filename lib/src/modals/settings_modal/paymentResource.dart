import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/paymentResourceApi.dart';
import 'package:money_hooks/src/class/response/paymentResource.dart';
import 'package:money_hooks/src/searchStorage/paymentResourceStorage.dart';

import '../../components/commonLoadingDialog.dart';
import '../../components/commonSnackBar.dart';
import '../../components/dataNotRegisteredBox.dart';
import '../../components/gradientBar.dart';
import '../../dataLoader/paymentResource.dart';
import '../../env/envClass.dart';

class PaymentResource extends StatefulWidget {
  const PaymentResource({Key? key, required this.env}) : super(key: key);
  final envClass env;

  @override
  State<PaymentResource> createState() => _SearchTransaction();
}

class _SearchTransaction extends State<PaymentResource> {
  late envClass env;
  late bool _isLoading;
  late List<PaymentResourceData> resultData = [];
  late PaymentResourceData editingData = PaymentResourceData();
  late PaymentResourceData newData = PaymentResourceData.init(null, "");

  void setLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void cancelEditMode(PaymentResourceData data) {
    setState(() {
      for (var value in resultData) {
        value.editMode = false;
      }
    });
  }

  TextEditingController setController(String text) {
    TextEditingController controller = TextEditingController(text: text);
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return controller;
  }

  void setSnackBar(String message) {
    setState(() {
      CommonSnackBar.build(context: context, text: message);
    });
  }

  void setPaymentResourceList(dynamic resultList) {
    setState(() {
      resultData = [];
      if (resultList != null) {
        resultList.forEach((value) {
          resultData.add(PaymentResourceData.init(
              value['payment_id'], value['payment_name']));
        });
      }
    });
  }

  Future<void> reloadList() async {
    await PaymentResourceStorage.deletePaymentResourceList();
    await PaymentResourceApi.getPaymentResourceList(
        env, setPaymentResourceList);
  }

  Future<void> sendPaymentData(PaymentResourceData data) async {
    commonLoadingDialog(context: context);
    if (data.paymentId != null) {
      // 編集処理
      //   await PaymentResourceApi.editPaymentResource(
      //           data, reloadList, setSnackBar)
      //       .then((value) {
      //     setSnackBar("Hoops!編集処理はまだ実装されていません");
      //   });
      setSnackBar("Hoops!編集処理はまだ実装されていません");
      Navigator.pop(context);
    } else {
      // 追加処理
      await PaymentResourceApi.addPaymentResource(data, reloadList, setSnackBar)
          .then((value) {
        newData.paymentName = "";
        if (data.paymentNameError == "") {
          // 処理成功
          data.editMode = false;
        }
        Navigator.pop(context);
      });
    }
  }

  Future<void> deletePayment(PaymentResourceData data) async {
    if (data.paymentId == null) {
      newData.paymentName = "";
      resultData.removeLast();
      return;
    }
    commonLoadingDialog(context: context);
    // 削除処理
    await PaymentResourceApi.deletePaymentResource(data, setSnackBar);
    await reloadList().then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    env = widget.env;
    _isLoading = false;
    PaymentResourceLoad.getPaymentResource(env, setPaymentResourceList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientBar(),
          title: (const Text('設定')),
        ),
        body: ListView(
          children: [
            resultData.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: resultData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _card(resultData[index]);
                    },
                  )
                : const dataNotRegisteredBox(message: '支払い方法が存在しません'),
            Center(
              heightFactor: 2,
              child: Tooltip(
                message: "新規支払い方法",
                child: IconButton(
                    // 新規追加ボタン
                    onPressed: () {
                      setState(() {
                        if (resultData.isEmpty ||
                            resultData.last.paymentId != null) {
                          newData.editMode = true;
                          editingData.paymentName = "";
                          resultData.add(newData);
                        }
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline)),
              ),
            ),
          ],
        ));
  }

  Widget _card(PaymentResourceData data) {
    return Card(
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            setState(() {
              cancelEditMode(data);
              data.editMode = true;
              editingData.paymentName = data.paymentName;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: data.editMode
                ? TextField(
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        data.paymentName = value;
                      });
                    },
                    controller: setController(data.paymentName),
                    decoration: InputDecoration(
                        labelText: '支払い名',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Tooltip(
                              message: "戻す",
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (editingData.paymentName != "") {
                                        data.paymentName =
                                            editingData.paymentName;
                                      }
                                      data.editMode = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.redo,
                                    textDirection: TextDirection.rtl,
                                  )),
                            ),
                            Tooltip(
                              message: "登録",
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      sendPaymentData(data);
                                    });
                                  },
                                  icon: const Icon(Icons.send)),
                            ),
                          ],
                        ),
                        errorText: data.paymentNameError != ""
                            ? data.paymentNameError
                            : null),
                    style: const TextStyle(fontSize: 20),
                  )
                : Row(
                    children: [
                      Text(data.paymentName,
                          style: const TextStyle(fontSize: 16)),
                      const Expanded(child: SizedBox()),
                      const Tooltip(message: "編集", child: Icon(Icons.edit)),
                      const SizedBox(width: 20),
                      Tooltip(
                        message: "削除",
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                deletePayment(data);
                              });
                            },
                            icon: const Icon(Icons.delete_outline)),
                      )
                    ],
                  ),
          ),
        ));
  }
}
