import 'package:chic/bean/currency.dart';
import 'package:chic/widget/budgetlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chic/widget/home.dart';
import 'package:chic/bean/db.dart';

void main() async {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  // InitDB
  await dbHelper.getDb();

  runApp(new MaterialApp(
    title: "Chic",
    initialRoute: "/",
    routes: {
      "/": (context) => new HomePage(),
      "/budget_list": (context) => new BudgetList(),
    },
  ));
}
