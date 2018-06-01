import 'package:chic/bean/db.dart';
import 'package:chic/widget/budgetlist.dart';
import 'package:chic/widget/home.dart';
import 'package:flutter/material.dart';

void main() async {
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
