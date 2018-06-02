import 'package:chic/bean/budget.dart';
import 'package:chic/util/display.dart';
import 'package:flutter/material.dart';

class _CardItemState extends State<CardItem> {
  double _mainLisItemWidth;
  double _iconSize = 1.0;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _mainLisItemWidth = screenWidth - 48.0;
    // 初始化动画
    final Animation curve =
        new CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut);
    final Tween doubleTween = new Tween<double>(
        begin: _mainLisItemWidth, end: _mainLisItemWidth - 120);

    final Tween iconTween = new Tween<double>(
      begin: 1.0,
      end: 24.0,
    );

    curve.addListener(() {
      setState(() {
        _mainLisItemWidth = doubleTween.evaluate(curve);
        _iconSize = iconTween.evaluate(curve);
      });
    });
  }

  @override
  void didUpdateWidget(CardItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(10.0),
      child: new GestureDetector(
        onTap: () {
          widget.onTap(widget.index);
        },
        onHorizontalDragEnd: (d) {
          if (!widget.controller.isAnimating) {
            if (d.velocity.pixelsPerSecond.dx > 0) {
              // 向右
              widget.controller.reverse();
            } else {
              // 向左
              widget.controller.forward();
              widget.onExpand(widget.index);
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
                    iconSize: _iconSize,
                    splashColor: Colors.orange,
                    icon: new Icon(Icons.edit),
                    color: Colors.grey.shade600,
                    onPressed: () {},
                  ),
                  new IconButton(
                    iconSize: _iconSize,
                    splashColor: Colors.orange,
                    icon: new Icon(Icons.delete),
                    color: Colors.redAccent,
                    onPressed: () {
                      // 提示
                      _showDeleteDialog(context);
                    },
                  )
                ],
              ),
            ),
            new Container(
              alignment: AlignmentDirectional.center,
              width: _mainLisItemWidth,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
                color: widget.selected ? Colors.purple : Colors.grey.shade300,
              ),
              child: ListTile(
                title: new Text(widget.item.budgetName),
                subtitle: new Text("0 tasks"),
                trailing: widget.selected
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 28.0,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('是否删除'),
            content: new Text('确定删除第${widget.index+1}位，'
                '名字为${widget.item.budgetName}的预算吗？'),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  '取消',
                  style: new TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDelete(widget.index);
                },
              ),
            ],
          );
        });
  }
}

class CardItem extends StatefulWidget {
  CardItem({
    Key key,
    @required this.onTap,
    @required this.onExpand,
    @required this.onDelete,
    @required this.item,
    @required this.index,
    @required this.controller,
    this.selected: false,
  }) : super(key: key);

  final CardIndexCallback onTap;
  final CardIndexCallback onExpand;
  final CardIndexCallback onDelete;
  final Budget item;
  final bool selected;
  final int index;
  final AnimationController controller;

  @override
  State<StatefulWidget> createState() {
    return _CardItemState();
  }
}

typedef void CardIndexCallback(int index);
