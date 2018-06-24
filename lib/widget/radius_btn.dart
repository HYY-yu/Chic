import 'package:flutter/material.dart';

class RadiusButton extends StatelessWidget {
  final String text;
  final double horizontalPadding;
  final double textSize;

  const RadiusButton(
    this.text,
    this.horizontalPadding,
    this.textSize,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 8.0, horizontal: horizontalPadding),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(100.0))),
      child: new Text(
        text,
        style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w100,
            color: Colors.white,
            decoration: TextDecoration.none),
      ),
    );
  }
}
