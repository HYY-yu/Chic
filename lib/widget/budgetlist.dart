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
  List<Budget> datas;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: new EdgeInsets.all(8.0),
              child: Text(
                "我的预算列表 ($_budgetCount)",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Expanded(
              child: new ListView.builder(
                itemBuilder: _itemBuilder,
                itemCount: _budgetCount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var elem = datas[index];
    return new ListTile(
      title: new Text("${elem.budgetName}"),
    );
  }

  void _loadBudgetList() async {
    var budgetList = await Budget.getBudgetList();
    datas = budgetList;
    _budgetCount = budgetList.length;
    setState(() {});
  }
}
