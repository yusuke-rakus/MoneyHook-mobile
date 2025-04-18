import 'package:flutter/material.dart';
import 'package:money_hooks/common/class/paymentResource.dart';
import 'package:money_hooks/features/settings/class/paymentType.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceApi.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceLoad.dart';
import 'package:money_hooks/common/data/data/paymentResource/commonPaymentResourceStorage.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/common/widgets/cardWidget.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/widgets/commonConfirmDialog.dart';
import 'package:money_hooks/common/widgets/commonLoadingDialog.dart';
import 'package:money_hooks/common/widgets/commonSnackBar.dart';
import 'package:money_hooks/common/widgets/dataNotRegisteredBox.dart';
import 'package:money_hooks/common/widgets/gradientBar.dart';
import 'package:money_hooks/features/settings/data/paymentResource/paymentResourceApi.dart';

class PaymentResource extends StatefulWidget {
  const PaymentResource({super.key, required this.env});

  final EnvClass env;

  @override
  State<PaymentResource> createState() => _SearchTransaction();
}

class _SearchTransaction extends State<PaymentResource> {
  late EnvClass env;
  late bool _isLoading;
  late List<PaymentResourceData> resultData = [];
  late List<PaymentTypeData> paymentTypeResult = [];
  late PaymentResourceData editingData = PaymentResourceData();
  late PaymentResourceData newData =
      PaymentResourceData.init(null, "", null, null, 31);

  void setLoading() {
    setState(() => _isLoading = !_isLoading);
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
    setState(() => CommonSnackBar.build(context: context, text: message));
  }

  void setPaymentResourceList(List<PaymentResourceData> resultList) {
    setState(() {
      if (resultList != []) {
        resultData = [];
        for (var value in resultList) {
          resultData.add(value);
        }
      }
    });
  }

  void setPaymentTypeList(List<PaymentTypeData> resultList) {
    setState(() {
      if (resultList != []) {
        paymentTypeResult = [];
        for (var value in resultList) {
          paymentTypeResult.add(value);
        }
      }
    });
  }

  Future<void> reloadList() async {
    await CommonPaymentResourceStorage.deletePaymentResourceList();
    await CommonPaymentResourceApi.getPaymentResourceList(
        env, setPaymentResourceList);
  }

  Future<void> sendPaymentData(PaymentResourceData data) async {
    commonLoadingDialog(context: context);
    if (data.paymentId != null) {
      // 編集処理
      await PaymentResourceApi.editPaymentResource(
              data, reloadList, setSnackBar)
          .then((value) {
        Navigator.pop(context);
      });
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
    CommonPaymentResourceLoad.getPaymentResource(env, setPaymentResourceList);
    PaymentResourceApi.getPaymentType(env, setPaymentTypeList);
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: resultData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _card(resultData[index]);
                    },
                  )
                : const DataNotRegisteredBox(message: '支払い方法が存在しません'),
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
                          newData.paymentTypeId =
                              paymentTypeResult.first.paymentTypeId;
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
    return CenterWidget(
      child: CardWidget(
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
                  ? ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TextField(
                          autofocus: true,
                          onChanged: (value) =>
                              setState(() => data.paymentName = value),
                          controller: setController(data.paymentName),
                          decoration: InputDecoration(
                              labelText: '支払い名',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Tooltip(
                                    message: "戻す",
                                    child: IconButton(
                                        onPressed: () => setState(() {
                                              if (editingData.paymentName !=
                                                  "") {
                                                data.paymentName =
                                                    editingData.paymentName;
                                              }
                                              data.editMode = false;
                                            }),
                                        icon: const Icon(
                                          Icons.redo,
                                          textDirection: TextDirection.rtl,
                                        )),
                                  ),
                                  Tooltip(
                                    message: "登録",
                                    child: IconButton(
                                        onPressed: () {
                                          sendPaymentData(data);
                                        },
                                        icon: const Icon(Icons.send)),
                                  ),
                                ],
                              ),
                              errorText: data.paymentNameError != ""
                                  ? data.paymentNameError
                                  : null),
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 13.0),
                        paymentTypeResult.isNotEmpty
                            ? Text('支払い種別を選択', style: TextStyle(fontSize: 12.5))
                            : const SizedBox(),
                        paymentTypeResult.isNotEmpty
                            ? Wrap(
                                children: paymentTypeResult
                                    .map<Widget>((paymentType) =>
                                        _paymentTypeButton(paymentType, data))
                                    .toList())
                            : const SizedBox(),
                        paymentTypeResult.isNotEmpty
                            ? Wrap(children: [
                                _inputInvoiceDate(paymentTypeResult, data),
                                _inputClosingDate(paymentTypeResult, data)
                              ])
                            : const SizedBox()
                      ],
                    )
                  : Row(
                      children: [
                        Text(data.paymentName, style: TextStyle(fontSize: 16)),
                        const Expanded(child: SizedBox()),
                        const Tooltip(message: "編集", child: Icon(Icons.edit)),
                        const SizedBox(width: 20),
                        Tooltip(
                          message: "削除",
                          child: IconButton(
                              onPressed: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        commonConfirmDialog(
                                            context: context,
                                            title: '支払い方法を削除しますか',
                                            secondaryText: 'キャンセル',
                                            primaryText: '削除',
                                            primaryFunction: () {
                                              // 削除処理
                                              Navigator.pop(context);
                                              deletePayment(data);
                                            }));
                              },
                              icon: const Icon(Icons.delete_outline)),
                        )
                      ],
                    ),
            ),
          )),
    );
  }

  Widget _paymentTypeButton(
      PaymentTypeData data, PaymentResourceData paymentResource) {
    return Container(
      height: 23,
      margin: const EdgeInsets.only(top: 3, right: 5),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            paymentResource.paymentTypeId = data.paymentTypeId;
            paymentResource.paymentDate = null;
          });
        },
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            foregroundColor: paymentResource.paymentTypeId == data.paymentTypeId
                ? Colors.white
                : Colors.black87,
            backgroundColor: paymentResource.paymentTypeId == data.paymentTypeId
                ? const Color(0xFF42A5F5)
                : const Color(0xFFBDBDBD),
            side: const BorderSide(color: Colors.transparent)),
        child: Text(data.paymentTypeName),
      ),
    );
  }

  Widget _inputInvoiceDate(List<PaymentTypeData> paymentTypeList,
      PaymentResourceData paymentResource) {
    PaymentTypeData data = paymentTypeList
        .where((item) => item.paymentTypeId == paymentResource.paymentTypeId)
        .toList()
        .first;
    final dateList = [for (int i = 1; i < 32; i++) i];
    return data.isPaymentDueLater
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("引落日を選択: ", style: TextStyle(fontSize: 12.5)),
              DropdownButton(
                hint: const Text("支払日"),
                value: paymentResource.paymentDate,
                items: dateList
                    .map((date) =>
                        DropdownMenuItem(value: date, child: Text('$date日')))
                    .toList(),
                onChanged: (value) async {
                  setState(() => paymentResource.paymentDate = value);
                },
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _inputClosingDate(List<PaymentTypeData> paymentTypeList,
      PaymentResourceData paymentResource) {
    PaymentTypeData data = paymentTypeList
        .where((item) => item.paymentTypeId == paymentResource.paymentTypeId)
        .toList()
        .first;
    final dateList = [for (int i = 1; i < 32; i++) i];
    return data.isPaymentDueLater
        ? Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("締日を選択: ", style: TextStyle(fontSize: 12.5)),
                DropdownButton(
                  hint: const Text("締日"),
                  value: paymentResource.closingDate,
                  items: dateList
                      .map((date) =>
                          DropdownMenuItem(value: date, child: Text('$date日')))
                      .toList(),
                  onChanged: (value) async {
                    setState(() => paymentResource.closingDate = value);
                  },
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
