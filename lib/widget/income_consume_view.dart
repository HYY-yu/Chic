import 'package:chic/bean/budget.dart';
import 'package:chic/util/display.dart';
import 'package:flutter/material.dart';

class _Page {
  const _Page({this.icon, this.text});

  final IconData icon;
  final String text;
}

const List<_Page> _allPagesConsume = const [
  const _Page(icon: Icons.star, text: "常用"),
  const _Page(icon: Icons.restaurant, text: "餐饮"),
  const _Page(icon: Icons.train, text: "交通"),
  const _Page(icon: Icons.shopping_basket, text: "购物"),
  const _Page(icon: Icons.local_activity, text: "娱乐"),
  const _Page(icon: Icons.weekend, text: "居家"),
  const _Page(icon: Icons.school, text: "教育"),
  const _Page(icon: Icons.trending_up, text: "投资"),
  const _Page(icon: Icons.local_hospital, text: "医疗"),
  const _Page(icon: Icons.people, text: "人际"),
];

const List<_Page> _allPagesIncome = const [
  const _Page(icon: Icons.star, text: "常用"),
  const _Page(icon: Icons.credit_card, text: "稳定收入"),
  const _Page(icon: Icons.attach_money, text: "额外收入"),
];

class IncomeOrConsumeView extends StatefulWidget {
  // 收入页还是支出页
  final bool isIncome;
  final String currencyName;
  final Budget currentBudget;
  final List<_Page> _allPage = new List<_Page>();

  IncomeOrConsumeView(
      {Key key,
      @required this.isIncome,
      @required this.currencyName,
      @required this.currentBudget})
      : super(key: key) {
    _allPage.addAll(isIncome ? _allPagesIncome : _allPagesConsume);
  }

  @override
  State<StatefulWidget> createState() => _IncomeOrConsumeViewState();
}

class _IncomeOrConsumeViewState extends State<IncomeOrConsumeView>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        new TabController(length: widget._allPage.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Decoration getIndicator() {
    return new ShapeDecoration(
      shape: const CircleBorder(
            side: const BorderSide(
              color: Colors.orange,
              width: 4.0,
            ),
          ) +
          const CircleBorder(
            side: const BorderSide(
              color: Colors.transparent,
              width: 4.0,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(widget.isIncome ? "收入" : "支出"),
        ),
        body: Column(
          children: <Widget>[
            _pageHead(),
            _pageTab(),
            _pageTabBody(),
          ],
        ));
  }

  Widget _pageTabBody() {
    return Expanded(
      flex: 6,
      child: Container(
        child: SafeArea(
          child: TabBarView(
              controller: _controller,
              children: widget._allPage.map((page) {
                return Container(
                    key: ObjectKey(page.icon),
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text("data"),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Divider(
                                height: 1.0,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 14.0,
                              ),
                              Text(
                                page.text,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
              }).toList()),
        ),
      ),
    );
  }

  Widget _pageTab() {
    return Expanded(
      flex: 1,
      child: Container(
        width: screenWidth,
        color: Colors.grey[100],
        child: TabBar(
          labelColor: Colors.grey,
          controller: _controller,
          isScrollable: true,
          indicator: getIndicator(),
          tabs: widget._allPage
              .map((page) => new Tab(
                    icon: new Icon(page.icon),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _pageHead() {
    return Expanded(
      flex: 3,
      child: Container(
        color: widget.isIncome ? Color(0x666ec5ff) : Color(0x66ffc947),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "0.0",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 52.0,
                ),
              ),
              new SizedBox(
                height: 16.0,
              ),
              new Text(
                widget.currencyName,
                style: new TextStyle(
                    fontSize: 18.0,
                    decoration: TextDecoration.none,
                    color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
