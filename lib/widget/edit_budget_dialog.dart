import 'package:chic/bean/budget.dart';
import 'package:flutter/material.dart';

class EditBudgetDialog extends StatefulWidget {
  final Budget item;

  const EditBudgetDialog(this.item);

  @override
  State<StatefulWidget> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  @override
  Widget build(BuildContext context) {
    return new Text("data");
  }
}
