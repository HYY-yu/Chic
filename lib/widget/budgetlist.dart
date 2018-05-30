import 'package:chic/bean/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BudgetListState();
  }
}

class _BudgetListState extends State<BudgetList> {
  int _budgetCount = 0;

  @override
  void initState() {
    super.initState();
    _loadBudgetList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Text("预算列表"),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(24.0),
        child: new Column(
          children: <Widget>[
            Text(
              "我的预算列表 ($_budgetCount)",
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadBudgetList() async {
    var budgetList = await Budget.getBudgetList();
    _budgetCount = budgetList.length;
    setState(() {});
  }
}
