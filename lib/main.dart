import 'package:chic/bean/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chic/widget/home.dart';
import 'package:chic/bean/db.dart';

void main() async {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  // InitDB
  var db = await dbHelper.getDb();
  var lists = await db.rawQuery("SELECT * FROM ${Currency.tableName}");
  print(lists.toString());

  runApp(new MaterialApp(
    title: "Chic",
    home: new HomePage(),
  ));
}
