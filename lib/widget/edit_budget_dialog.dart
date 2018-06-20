import 'package:chic/bean/budget.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class EditBudgetDialog extends StatefulWidget {
  final Budget item;

  const EditBudgetDialog(this.item);

  @override
  State<StatefulWidget> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Budget _dataItem;

  @override
  void initState() {
    super.initState();
    _dataItem = new Budget.copy(widget.item);
  }

  String _validateAmount(String amount) {
    if (amount.isEmpty) {
      return null;
    }

    // 不超过两位小数
    var amountNum = double.tryParse(amount);
    if (amountNum == null) {
      return "不合法的金额";
    }

    if (amountNum <= 0) {
      return "请输入大于0的数字";
    }

    if (amount.contains(".")) {
      var spList = amount.split(".");
      if (spList.length != 2) {
        return "不合法的金额";
      }

      if (spList[1].length > 2) {
        return "不超过两位小数";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Text("我的预算"),
      ),
      backgroundColor: Colors.white,
      body: new Form(
        key: _formKey,
        autovalidate: false,
        child: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 24.0,
              ),
              new TextFormField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  contentPadding: const EdgeInsets.all(4.0),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "预算命名",
                  helperText: "不超过6个字符",
                  hintText: _dataItem.budgetName,
                ),
                onSaved: (value) {
                  _dataItem.budgetName = value;
                },
                validator: (va) {
                  if (va.isNotEmpty) {
                    if (va.runes.length > 6) {
                      return "名称不能超过6个字符";
                    }
                  }
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              new TextFormField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  contentPadding: const EdgeInsets.all(4.0),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "预算额度",
                  hintText: "${_dataItem.budgetTotal.toStringAsFixed(2)}",
                  helperText: "不超过两位小数",
                ),
                onSaved: (va) {
                  if (va.isNotEmpty) {
                    var total = double.parse(va);
                    _dataItem.budgetTotal = total;
                  }
                },
                validator: _validateAmount,
              ),
              const SizedBox(
                height: 12.0,
              ),
              new TextFormField(
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  contentPadding: const EdgeInsets.all(4.0),
                  fillColor: Colors.white,
                  filled: true,
                  labelText: "剩余额度",
                  hintText: "${_dataItem.budgetSurplus.toStringAsFixed(2)}",
                  helperText: "不超过两位小数",
                ),
                onSaved: (va) {
                  if (va.isNotEmpty) {
                    var surplus = double.parse(va);
                    _dataItem.budgetSurplus = surplus;
                  }
                },
                validator: _validateAmount,
              ),
              const SizedBox(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new SizedBox(
                    width: 8.0,
                    height: 24.0,
                  ),
                  new Expanded(child: new Text("是否滚存")),
                  new Checkbox(
                    value: _dataItem.budgetAccumulated,
                    onChanged: (c) {
                      setState(() {
                        _dataItem.budgetAccumulated = c;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              new GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return new Container(
                          padding: const EdgeInsets.all(32.0),
                          child: NumberPicker.integer(
                            initialValue: _dataItem.whichDayStart,
                            minValue: 1,
                            maxValue: 31,
                            onChanged: (num) {
                              setState(() {
                                _dataItem.whichDayStart = num;
                              });
                            },
                          ),
                        );
                      });
                },
                child: new Row(
                  children: <Widget>[
                    new SizedBox(
                      width: 8.0,
                    ),
                    new Expanded(child: new Text("每月开始日")),
                    new Text("Day ${_dataItem.whichDayStart}"),
                    new SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              new RaisedButton(
                onPressed: _handleSubmitted,
                color: Colors.grey.shade300,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: new Text("保 存"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      // Save
      Budget.updateBudgetFrom(_dataItem);
      Navigator.pop(context, _dataItem);
    }
  }
}
