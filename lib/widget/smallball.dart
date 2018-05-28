import 'package:chic/bean/currency.dart';
import 'package:flutter/material.dart';

import 'package:chic/util/display.dart';
import 'package:meta/meta.dart';

/// 圆形的球
/// 抽取界面的白色圆球部分的代码构成此Widget
///
/// 关键参数：
/// amount 金额
/// monetaryUnitFlag 货币名称
///

class SmallBall extends StatefulWidget {
  final double amount;
  final int currencyID;

  const SmallBall({Key key, @required this.amount, @required this.currencyID})
      : super(key: key);

  @override
  _SmallBallState createState() => new _SmallBallState();
}

class _SmallBallState extends State<SmallBall> {
  double radius;
  double fontSize;
  String monetaryFlag = "";

  @override
  void initState() {
    super.initState();
    //计算radius
    radius = screenWidth * (3 / 4);
    //字体大小
    fontSize = radius / 8;
  }

  void loadCurrency() async {
    monetaryFlag = await Currency.getCurrencyNameByID(widget.currencyID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var realAmount = double.parse(widget.amount.toStringAsFixed(2));
    loadCurrency();
    return new Container(
      width: radius,
      height: radius,
      child: new Stack(
        textDirection: TextDirection.ltr,
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  offset: new Offset(0.0, 5.0),
                  color: const Color(0x66333333),
                ),
              ],
              color: Colors.white,
            ),
          ),
          new RichText(
            text: new TextSpan(
              children: <TextSpan>[
                new TextSpan(
                    text: "\n$realAmount",
                    style: new TextStyle(
                      fontFamily: "Segoepr",
                      color: Colors.black87,
                      fontSize: fontSize,
                    )),
                new TextSpan(
                    text: "\n本月剩余",
                    style: new TextStyle(
                      color: Colors.grey,
                      fontSize: fontSize * 0.5,
                    )),
              ],
              text: monetaryFlag,
              style: new TextStyle(
                  fontSize: fontSize * 0.6,
                  decoration: TextDecoration.none,
                  color: Colors.orange),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
