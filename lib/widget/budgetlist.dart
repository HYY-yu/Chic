import 'package:chic/bean/budget.dart';
import 'package:chic/widget/card_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BudgetListState();
  }
}

class _BudgetListState extends State<BudgetList>
    with TickerProviderStateMixin{
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
      onDelete: (i) {
        _deleteTheItem(i);
      },
      onTap: (i) {
        if (_nowSelectIndex == i) {
          return;
        }

        if (controllers.length > 0) {
          for (var c in controllers) {
            if (c.isCompleted) {
              c.reverse();
              return;
            }
          }
        }

        // 记录到SharedPreference
        var e = datas[i];
        SharedPreferences.getInstance().then((pref) {
          pref.setString(Budget.SPBudgetKey, e.budgetID);
        });

        setState(() {
          _nowSelectIndex = i;
        });
      },
      controller: controller,
      onExpand: (i) {
        //取消上个Card的Expand
        if (_expandIndex != -1 && _expandIndex < datas.length) {
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

  void _deleteTheItem(int i) async {
    // 最后一个Item不能删除！
    if (datas.length == 1) {
      Fluttertoast.showToast(
        msg: "不能删除最后一个预算",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );
      return;
    }

    // 如果删除的正好是selectItem，需要更新到其它的选项
    if (_nowSelectIndex == i) {
      //碰到的第一个不是_nowSelectIndex的Item
      for (int j = 0; j < datas.length; j++) {
        if (j != _nowSelectIndex) {
          var pref = await SharedPreferences.getInstance();
          await pref.setString(Budget.SPBudgetKey, datas[j].budgetID);
          break;
        }
      }
    }

    var e = datas[i];
    Budget.deleteBudgetByBudgetID(e.budgetID).then((result) {
      _loadBudgetList();
    });
  }

  void _loadBudgetList() async {
    var budgetList = await Budget.getBudgetList();
    datas = budgetList;
    _budgetCount = budgetList.length;

    // 查询SelectIndex
    var pref = await SharedPreferences.getInstance();
    var selectID = pref.getString(Budget.SPBudgetKey);

    if (selectID != null) {
      for (int i = 0; i < budgetList.length; i++) {
        if (selectID == budgetList[i].budgetID) {
          _nowSelectIndex = i;
        }
      }
    }
    setState(() {});
  }
}
