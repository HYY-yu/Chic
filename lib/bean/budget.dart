import 'package:chic/bean/db.dart';
import 'package:chic/bean/currency.dart';

class Budget extends SQLModel {
  String _budgetID;
  String _budgetName;
  int _currencyID;
  int _startDateTime;
  double _budgetTotal;
  double _budgetSurplus;
  double _budgetAccumulated;

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName() ("
        "$fieldBudgetID INTEGER(8) NOT NULL, "
        "$fieldBudgetName TEXT(6) NOT NULL,"
        "$fieldCurrencyID INTEGER(2) NOT NULL,"
        "$fieldStartDateTime INTEGER(20) NOT NULL,"
        "$fieldBudgetTotal REAL(10,2) NOT NULL, "
        "$fieldBudgetSurplus REAL(10,2) NOT NULL, "
        "$fieldAccumulated INTEGER(1) NOT NULL, "
        "PRIMARY KEY ('budget_id') ,"
        "CONSTRAINT 'fk_budget_currency' FOREIGN KEY ($fieldCurrencyID) REFERENCES"
        " ${Currency.tableName()} (${Currency.fieldCurrencyID})"
        " ON DELETE RESTRICT ON UPDATE CASCADE"
        ")";
  }

  static String tableName() => "t_budget";
  static String fieldBudgetID = "budget_id";
  static String fieldBudgetName = "budget_name";
  static String fieldCurrencyID = "currency_id";
  static String fieldStartDateTime = "start_datetime";
  static String fieldBudgetTotal = "budget_total";
  static String fieldBudgetSurplus = "budget_surplus";
  static String fieldAccumulated = "budget_accumulated";

  double get budgetAccumulated => _budgetAccumulated;

  set budgetAccumulated(double value) {
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
