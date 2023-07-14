import 'package:localstore/localstore.dart';

import '../class/transactionClass.dart';

class transactionStorage {
  static final db = Localstore.instance;

  /// 【タイムライン画面】データ
  static Future<List<transactionClass>> searchTimelineData(
      String param, Function setLoading) async {
    setLoading();

    final id = 'timelineData$param';
    List<transactionClass> resultList = [];

    await db.collection('timelineData').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          String transactionId = e['transactionId'].toString();
          String transactionDate = e['transactionDate'];
          int transactionSign = e['transactionSign'];
          String transactionAmount = e['transactionAmount'].toString();
          String transactionName = e['transactionName'];
          String categoryName = e['categoryName'];
          bool fixedFlg = e['fixedFlg'];
          resultList.add(transactionClass.setTimelineFields(
              transactionId,
              transactionDate,
              transactionSign,
              int.parse(transactionAmount),
              transactionName,
              categoryName,
              fixedFlg));
        });
      }
    }).then((value) => setLoading());
    return resultList;
  }

  static void saveStorageTimelineData(
      List<transactionClass> resultList, String param) async {
    await db
        .collection('timelineData')
        .doc('timelineData$param')
        .set({'data': resultList.map((e) => e.getTransactionJson()).toList()});
  }

  static void deleteTimelineData() async {
    await db.collection('timelineData').delete();
  }

  /// 【タイムライン画面】グラフ
  static Future<List<transactionClass>> getTimelineChart(String param) async {
    final id = 'timelineChart$param';
    List<transactionClass> resultList = [];

    await db.collection('timelineChart').doc(id).get().then((value) {
      if (value != null) {
        value['data'].forEach((e) {
          resultList.add(transactionClass.setTimelineChart(
              e['transactionDate'], e['transactionAmount']));
        });
      }
    });
    return resultList;
  }

  static void saveStorageTimelineChart(
      List<transactionClass> resultList, String param) async {
    await db
        .collection('timelineChart')
        .doc('timelineChart$param')
        .set({'data': resultList.map((e) => e.getTransactionJson()).toList()});
  }

  static void deleteTimelineChart() async {
    await db.collection('timelineChart').delete();
  }

  /// 【ホーム画面】データ
  static Future<Map<String, dynamic>> getHome(String param) async {
    final id = 'homeData$param';
    Map<String, dynamic> resultMap = <String, dynamic>{};

    await db.collection('homeData').doc(id).get().then((value) {
      if (value != null) {
        resultMap['balance'] = value['balance'];
        resultMap['categoryList'] = value['categoryList'];
      }
    });
    return resultMap;
  }

  static void saveStorageHomeData(
      int balance, List<dynamic> resultList, String param) async {
    await db
        .collection('homeData')
        .doc('homeData$param')
        .set({'balance': balance, 'categoryList': resultList});
  }

  static void deleteHomeData() async {
    await db.collection('homeData').delete();
  }
}
