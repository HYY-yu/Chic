import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_demo/util/display.dart';
import 'package:flutter_app_demo/widget/blur.dart';
import 'package:flutter_app_demo/widget/smallball.dart';
import 'package:flutter_app_demo/util/time_test.dart';
import 'package:image/image.dart' as gimage;

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(new MaterialApp(
    title: "Chic",
    home: new HomePage(),
  ));
}

class HomePageState extends State<HomePage> {
  String eachDayTip = "查看每日预算";
  Widget secondPage = new Text("data");
  bool _first = true;

  GlobalKey globalKey = new GlobalKey();

  Future<Uint8List> _capturePngAndGaussianBlur() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    // 先缩放，取原图的0.5倍大小图片，减少模糊时间
    startReport();
    ui.Image image = await boundary.toImage(pixelRatio: 0.5);
    //转成rawRgba
    var pixelsData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    var pixels = pixelsData.buffer.asUint8List();
    printDuration();

    //使用新算法进行模糊
    startReport();
    processImageDataRGBA(pixels, 0, 0, image.width, image.height, 4);
    printDuration();

    //把pixels转回Image
    startReport();
    gimage.Image newImage =
        new gimage.Image.fromBytes(image.width, image.height, pixels);
    List<int> jpgList = gimage.encodePng(newImage);
    printDuration();
    return jpgList;
  }

  setSecondPage(Widget secondWidget) {
    setState(() {
      secondPage = secondWidget;
      _first = false;
    });
  }

  setFirstPage() {
    setState(() {
      eachDayTip = "查看每日预算";
      _first = true;
    });
  }

  onTapDownEachDay(TapDownDetails details) {
    if (secondPage is Text) {
      setState(() {
        eachDayTip = "计算中....";
      });
      _capturePngAndGaussianBlur().then((Uint8List imageBytes) {
        Image image = new Image.memory(
          imageBytes,
          width: screenWidth,
          height: screenHeight,
          fit: BoxFit.fill,
        );
        setSecondPage(
          new GestureDetector(
            onTap: () {
              setFirstPage();
            },
            child: image,
          ),
        );
      });
    } else {
      setSecondPage(secondPage);
    }
  }

  onTapDragEndEachDay(DragEndDetails detials) {
    setFirstPage();
  }

  onTapUpEachDay(TapUpDetails details) {
    setFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    initScreen(context);
    Widget crossFade = AnimatedCrossFade(
      duration: Duration(milliseconds: 800),
      crossFadeState:
          _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: widgetMain(this),
            ),
            Expanded(
              flex: 1,
              child: widgetBottom(),
            )
          ],
        ),
      ),
      secondChild: secondPage,
    );
    return RepaintBoundary(key: globalKey, child: crossFade);
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

Widget translucentCircleBtn(Widget icon) {
  return Padding(
    padding: EdgeInsets.all(18.0),
    child: Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: const Color(0x33000000)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: icon,
      ),
    ),
  );
}

Widget widgetBottom() {
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

Widget widgetMain(HomePageState homePage) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    textDirection: TextDirection.ltr,
    children: <Widget>[
      SmallBall(amount: 1000.0),
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
          onTapDown: homePage.onTapDownEachDay,
          onPanEnd: homePage.onTapDragEndEachDay,
          onTapUp: homePage.onTapUpEachDay,
          child: Container(
            padding:
                EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(100.0))),
            child: new Text(
              homePage.eachDayTip,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    ],
  );
}
