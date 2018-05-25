import 'package:flutter/material.dart';

class RadiusButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(100.0))),
      child: new Text(
        "查看每日预算",
        style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w100,
            color: Colors.white,
            decoration: TextDecoration.none),
      ),
    );
  }
}
