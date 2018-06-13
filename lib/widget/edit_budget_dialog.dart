import 'package:chic/bean/budget.dart';
import 'package:flutter/material.dart';

class EditBudgetDialog extends StatefulWidget {
  final Budget item;

  const EditBudgetDialog(this.item);

  @override
  State<StatefulWidget> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Budget dataItem;

  @override
  void initState() {
    super.initState();
    dataItem = new Budget.copy(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        title: new Text("我的预算"),
      ),
      backgroundColor: Colors.white,
      body: new Form(
        key: _formKey,
        autovalidate: true,
        child: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 24.0,
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  labelText: "预算命名",
                  hintText: "不超过6个字符",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
