import 'package:chic/bean/budget.dart';
import 'package:chic/util/display.dart';
import 'package:flutter/material.dart';

class BudgetList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BudgetListState();
  }
}

class _BudgetListState extends State<BudgetList>
    with SingleTickerProviderStateMixin {
  List<Budget> datas;
  int _budgetCount = 0;
  double _mainLisItemWidth;

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    _mainLisItemWidth = screenWidth - 48.0;
    _loadBudgetList();

    // 初始化动画
    controller = new AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    final Animation curve =
        new CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    final Tween doubleTween = new Tween<double>(
        begin: _mainLisItemWidth, end: _mainLisItemWidth - 110);

    curve.addListener(() {
      setState(() {
        _mainLisItemWidth = doubleTween.evaluate(curve);
      });
    });
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
    var elem = datas[index];
    return new GestureDetector(
      onHorizontalDragEnd: (d) {
        if (!controller.isAnimating) {
          if (d.velocity.pixelsPerSecond.dx > 0) {
            // 向右
            controller.reverse();
          } else {
            // 向左
            controller.forward();
          }
        }
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          new Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              children: <Widget>[
                new IconButton(
                  splashColor: Colors.orange,
                  icon: new Icon(Icons.edit),
                  onPressed: () {},
                ),
                new IconButton(
                  splashColor: Colors.orange,
                  icon: new Icon(Icons.delete),
                  onPressed: () {},
                )
              ],
            ),
          ),
          new Container(
            width: _mainLisItemWidth,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
              color: Colors.grey.shade300,
            ),
            child: ListTile(
              title: new Text(elem.budgetName),
              subtitle: new Text("0 tasks"),
              trailing: new Icon(Icons.check_circle),
            ),
          ),
        ],
      ),
    );
  }

  void _loadBudgetList() async {
    var budgetList = await Budget.getBudgetList();
    datas = budgetList;
    _budgetCount = budgetList.length;
    setState(() {});
  }
}
