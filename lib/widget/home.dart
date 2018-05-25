import 'package:chic/util/display.dart';
import 'package:chic/widget/smallball.dart';
import 'package:chic/widget/radius_btn.dart';
import 'package:chic/util/monerary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

/// 首页
///
///

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Monerary monetaryUnitFlag = Monerary.RMB;

  AnimationController controller;
  final double MAXSIGMA = 5.0;
  final double MINSIGMA = 0.0;
  double sigma;
  double secondOpacity = 0.0;

  GlobalKey globalKey = new GlobalKey();
  bool _first = true;

  @override
  void initState() {
    super.initState();
    sigma = MINSIGMA;

    // 初始化动画
    controller = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    final Animation curve =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);

    final Tween doubleTween = new Tween<double>(begin: MINSIGMA, end: MAXSIGMA);
    final Tween opacityTween = new Tween<double>(begin: 0.0, end: 1.0);

    curve.addListener(() {
      setState(() {
        secondOpacity = opacityTween.evaluate(curve);
        sigma = doubleTween.evaluate(curve);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreen(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _firstPage(),
        new IgnorePointer(
          child: _secondPage(),
        )
      ],
    );
  }

  setSecondPage() {
    controller.reset();
    controller.forward();
    setState(() {
      _first = false;
    });
  }

  setFirstPage() {
    controller.stop();
    setState(() {
      _first = true;
    });
  }

  onTapDownEachDay(TapDownDetails details) {
    setSecondPage();
  }

  onTapDragEndEachDay(DragEndDetails detials) {
    setFirstPage();
  }

  onTapUpEachDay(TapUpDetails details) {
    setFirstPage();
  }

  Widget _firstPage() {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: widgetMain(),
          ),
          Expanded(
            flex: 1,
            child: HomeBottomBtn(),
          )
        ],
      ),
    );
  }

  Widget _secondPage() {
    return Opacity(
      opacity: _first ? 0.0 : 1.0,
      child: new BackdropFilter(
        filter: new ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Opacity(
          opacity: secondOpacity,
          child: Container(
            color: Colors.black.withOpacity(0.01),
            child: new Center(
              child: new RichText(
                text: new TextSpan(
                  children: <TextSpan>[
                    new TextSpan(
                        text: "\n100.0",
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 48.0,
                        )),
                    new TextSpan(
                        text: "\n今日剩余",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                  ],
                  text: '${getMonetaryDisplayString(monetaryUnitFlag)}',
                  style: new TextStyle(
                      fontSize: 18.0,
                      decoration: TextDecoration.none,
                      color: Colors.orange),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetMain() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: <Widget>[
        SmallBall(
          amount: 1000.0,
          monetaryUnitFlag: monetaryUnitFlag,
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: Text(
            "本月还有",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "29天",
            style: TextStyle(
              fontSize: 26.0,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: GestureDetector(
            onTapDown: onTapDownEachDay,
            onPanEnd: onTapDragEndEachDay,
            onTapUp: onTapUpEachDay,
            child: RadiusButton(),
          ),
        ),
      ],
    );
  }
}

class HomeBottomBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
      Align(
          alignment: AlignmentDirectional.bottomStart,
          child: translucentCircleBtn(Icon(
            Icons.assignment,
            color: Colors.white,
          ))),
      Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: translucentCircleBtn(Icon(
            Icons.menu,
            color: Colors.white,
          ))),
    ]));
  }

  Widget translucentCircleBtn(Widget icon) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: const Color(0x33000000)),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: icon,
        ),
      ),
    );
  }
}
