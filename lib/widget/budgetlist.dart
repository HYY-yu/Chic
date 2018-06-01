import 'package:chic/bean/budget.dart';
import 'package:chic/widget/card_item.dart';
import 'package:flutter/material.dart';

class BudgetList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BudgetListState();
  }
}

class _BudgetListState extends State<BudgetList> with TickerProviderStateMixin {
  List<Budget> datas;
  List<AnimationController> controllers;
  int _budgetCount = 0;
  int _expandIndex = -1;
  int _nowSelectIndex = 0;

  @override
  void initState() {
    super.initState();
    controllers = new List<AnimationController>();
    _loadBudgetList();
  }

  @override
  Widget build(BuildContext context) {
    controllers.clear();
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
              padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
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
    var controller = new AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    controllers.add(controller);

    Widget item = new CardItem(
      selected: index == _nowSelectIndex ? true : false,
      item: datas[index],
      index: index,
      onTap: (i) {
        if (_nowSelectIndex == i) {
          return;
        }

        if (controllers.length > 0) {
          for (var c in controllers) {
            if (c.isCompleted){
              c.reverse();
              return;
            }
          }
        }

        setState(() {
          _nowSelectIndex = i;
        });
      },
      controller: controller,
      onExpand: (i) {
        //取消上个Card的Expand
        if (_expandIndex != -1) {
          var c = controllers[_expandIndex];
          if (c != null && c.isCompleted) {
            c.reverse();
          }
        }
        _expandIndex = i;
      },
    );

    return item;
  }

  void _loadBudgetList() async {
    var budgetList = await Budget.getBudgetList();
    datas = budgetList;
    _budgetCount = budgetList.length;
    setState(() {});
  }
}
