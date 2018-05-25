import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chic/widget/home.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(new MaterialApp(
    title: "Chic",
    home: new HomePage(),
  ));
}
