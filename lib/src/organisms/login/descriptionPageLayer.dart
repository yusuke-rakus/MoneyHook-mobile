import 'package:flutter/material.dart';
import 'package:money_hooks/src/components/cardWidget.dart';
import 'package:money_hooks/src/components/centerWidget.dart';

class DescriptionPageLayer extends StatelessWidget {
  final bool secondVisible;

  const DescriptionPageLayer({super.key, required this.secondVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: AnimatedOpacity(
            opacity: secondVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: ListView(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  CenterWidget(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text('機能のご紹介', style: TextStyle(fontSize: 20)))),
                  const SizedBox(height: 10),
                  CenterWidget(
                      color: Colors.white,
                      child: LayoutBuilder(builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        double itemWidth = 300.0;
                        double viewportFraction = itemWidth / screenWidth;

                        return Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            height: 550,
                            child: PageView(
                                controller: PageController(
                                    viewportFraction: viewportFraction),
                                children: [
                                  _fixedWidthPage(
                                      context: context,
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-home.png',
                                          fit: BoxFit.contain),
                                      title: 'ホーム画面',
                                      description:
                                          '支出が円グラフで表示され、\nカテゴリ毎の合計支出を閲覧できます。'),
                                  _fixedWidthPage(
                                      context: context,
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-timeline.png',
                                          fit: BoxFit.contain),
                                      title: 'タイムライン一覧表示',
                                      description:
                                          '支出推移のグラフが表示されます。\nまた、今月の支出リストが表示されます。'),
                                  _fixedWidthPage(
                                      context: context,
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-calendar.png',
                                          fit: BoxFit.contain),
                                      title: 'カレンダー表示',
                                      description:
                                          'カレンダーに支出額が表示されます。\n日付をタップすることで内訳の確認ができます。'),
                                  _fixedWidthPage(
                                      context: context,
                                      width: itemWidth,
                                      child: Image.asset(
                                          'images/phone-payment.png',
                                          fit: BoxFit.contain),
                                      title: '支払い方法毎のまとめ機能',
                                      description:
                                          '支払い方法毎にまとめて表示でき、支出の管理が可能です。'),
                                ]));
                      }))
                ])));
  }

  static Widget _fixedWidthPage({
    required BuildContext context,
    required double width,
    required Widget child,
    required String title,
    required String description,
  }) {
    double imageWidth = width - 120;
    return Center(
        child: Container(
            width: width,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: CardWidget(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            title,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )),
                      Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          width: imageWidth,
                          child: child),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(description,
                              style: TextStyle(
                                  color: Color(0xFF303030), fontSize: 12))),
                    ])))));
  }
}
