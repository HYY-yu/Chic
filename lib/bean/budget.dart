import 'dart:async';

import 'package:chic/bean/currency.dart';
import 'package:chic/bean/db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class Budget extends SQLModel {
  static String SPBudgetKey = "SPBudgetKey";

  String budgetID;
  String budgetName;
  int currencyID;
  int startDateTime;
  int whichDayStart;
  double budgetTotal;
  double budgetSurplus;
  bool budgetAccumulated;

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

  Budget.copy(Budget old) {
    this.budgetID = old.budgetID;
    this.budgetName = old.budgetName;
    this.currencyID = old.currencyID;
    this.startDateTime = old.startDateTime;
    this.whichDayStart = old.whichDayStart;
    this.budgetTotal = old.budgetTotal;
    this.budgetSurplus = old.budgetSurplus;
    this.budgetAccumulated = old.budgetAccumulated;
  }

  Budget.newBudget(
      this.budgetID,
      this.budgetName,
      this.currencyID,
      this.startDateTime,
      this.whichDayStart,
      this.budgetTotal,
      this.budgetSurplus,
      this.budgetAccumulated);

  static Future<void> initBudgetTable(Database db) async {
    var now = DateTime.now();
    var uuid = new Uuid();

    var budget = Budget.newBudget(uuid.v1(), "我的账本", 3,
        now.millisecondsSinceEpoch, 1, 2000.0, 1980.0, false);

    var budget2 = Budget.newBudget(uuid.v1(), "她的账本", 2,
        now.millisecondsSinceEpoch, 15, 1000.0, 983.0, false);

    var budget3 = Budget.newBudget(uuid.v1(), "私房钱", 1,
        now.millisecondsSinceEpoch, 10, 500.0, 182.0, false);

    var pref = await SharedPreferences.getInstance();
    await pref.setString(SPBudgetKey, budget3.budgetID);

    await _insert(db, budget);
    await _insert(db, budget2);
    await _insert(db, budget3);
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

  static Future<int> updateBudgetFrom(Budget updateBudget) async {
    var data = updateBudget.toMap();
    data.remove("$fieldBudgetID");
    return updateBudgetBy(updateBudget.budgetID, data);
  }

  static Future<int> updateBudgetBy(String budgetID, Map<String, dynamic> data) async {
    var db = await dbHelper.getDb();
    return db.update(tableName, data,
        where: "$fieldBudgetID = ?", whereArgs: [budgetID]);
  }

  static Future<int> deleteBudgetByBudgetID(String budgetID) async {
    var db = await dbHelper.getDb();
    var result = await db
        .delete(tableName, where: "$fieldBudgetID = ?", whereArgs: [budgetID]);
    return result;
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

}
