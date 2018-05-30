import 'dart:async';

import 'package:chic/bean/db.dart';
import 'package:chic/bean/currency.dart';
import 'package:sqflite/sqflite.dart';

class Budget extends SQLModel {
  String _budgetID;
  String _budgetName;
  int _currencyID;
  int _startDateTime;
  int _whichDayStart;
  double _budgetTotal;
  double _budgetSurplus;
  bool _budgetAccumulated;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      fieldBudgetID: budgetID,
      fieldBudgetName: budgetName,
      fieldCurrencyID: currencyID,
      fieldStartDateTime: startDateTime,
      fieldWhichDayStart: whichDayStart,
      fieldBudgetTotal: budgetTotal,
      fieldBudgetSurplus: budgetSurplus,
      fieldBudgetAccumulated: budgetAccumulated,
    };
    return map;
  }

  Budget();

  Budget.fromMap(Map<String, dynamic> map) {
    budgetID = map[fieldBudgetID];
    budgetName = map[fieldBudgetName];
    currencyID = map[fieldCurrencyID];
    startDateTime = map[fieldStartDateTime];
    whichDayStart = map[fieldWhichDayStart];
    budgetTotal = map[fieldBudgetTotal];
    budgetSurplus = map[fieldBudgetSurplus];
    var temp = map[fieldBudgetAccumulated];
    if (temp is int) {
      budgetAccumulated = temp == 0 ? false : true;
    } else {
      budgetAccumulated = temp;
    }
  }

  Budget.newBudget(
      this._budgetID,
      this._budgetName,
      this._currencyID,
      this._startDateTime,
      this._whichDayStart,
      this._budgetTotal,
      this._budgetSurplus,
      this._budgetAccumulated);

  static Future<void> initBudgetTable(Database db) async {
    var now = DateTime.now();
    var budget = Budget.newBudget("test_budget", "我的账本", 1,
        now.millisecondsSinceEpoch, 1, 2000.0, 1980.0, false);
    await _insert(db, budget);
  }

  static Future<void> _insert(Database db, Budget elem) async {
    db.insert(tableName, elem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  static Future<Budget> getBudgetByBudgetID(String budgetID) async {
    var db = await dbHelper.getDb();
    var budgetList = await db
        .query(tableName, where: "$fieldBudgetID = ?", whereArgs: [budgetID]);

    if (budgetList.length > 0) {
      return Budget.fromMap(budgetList.first);
    }
    return null;
  }

  static Future<List<Budget>> getBudgetList() async {
    var db = await dbHelper.getDb();
    var budgetListMap = await db.query(tableName);

    var budgetList = new List<Budget>();
    for (var elem in budgetListMap) {
      var newElem = Budget.fromMap(elem);
      budgetList.add(newElem);
    }

    return budgetList;
  }

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName ("
        "$fieldBudgetID INTEGER(8) NOT NULL, "
        "$fieldBudgetName TEXT(6) NOT NULL,"
        "$fieldCurrencyID INTEGER(2) NOT NULL,"
        "$fieldStartDateTime INTEGER(20) NOT NULL,"
        "$fieldWhichDayStart INTEGER(10) NOT NULL,"
        "$fieldBudgetTotal REAL(10,2) NOT NULL, "
        "$fieldBudgetSurplus REAL(10,2) NOT NULL, "
        "$fieldBudgetAccumulated INTEGER(1) NOT NULL, "
        "PRIMARY KEY ('budget_id') ,"
        "CONSTRAINT 'fk_budget_currency' FOREIGN KEY ($fieldCurrencyID) REFERENCES"
        " ${Currency.tableName} (${Currency.fieldCurrencyID})"
        " ON DELETE RESTRICT ON UPDATE CASCADE"
        ")";
  }

  static String tableName = "t_budget";
  static String fieldBudgetID = "budget_id";
  static String fieldBudgetName = "budget_name";
  static String fieldCurrencyID = "currency_id";
  static String fieldStartDateTime = "start_datetime";
  static String fieldWhichDayStart = "which_day_start";
  static String fieldBudgetTotal = "budget_total";
  static String fieldBudgetSurplus = "budget_surplus";
  static String fieldBudgetAccumulated = "budget_accumulated";

  bool get budgetAccumulated => _budgetAccumulated;

  set budgetAccumulated(bool value) {
    _budgetAccumulated = value;
  }

  double get budgetSurplus => _budgetSurplus;

  set budgetSurplus(double value) {
    _budgetSurplus = value;
  }

  double get budgetTotal => _budgetTotal;

  set budgetTotal(double value) {
    _budgetTotal = value;
  }

  int get startDateTime => _startDateTime;

  set startDateTime(int value) {
    _startDateTime = value;
  }

  int get whichDayStart => _whichDayStart;

  set whichDayStart(int value) {
    _whichDayStart = value;
  }

  int get currencyID => _currencyID;

  set currencyID(int value) {
    _currencyID = value;
  }

  String get budgetName => _budgetName;

  set budgetName(String value) {
    _budgetName = value;
  }

  String get budgetID => _budgetID;

  set budgetID(String value) {
    _budgetID = value;
  }
}
