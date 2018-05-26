import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chic/widget/home.dart';
import 'package:chic/bean/db.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  // InitDB
  dbHelper.getDb().then((db){
  });

  runApp(new MaterialApp(
    title: "Chic",
    home: new HomePage(),
  ));
}
