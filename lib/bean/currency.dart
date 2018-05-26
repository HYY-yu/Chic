import 'package:chic/bean/db.dart';

class Currency extends SQLModel {
  int _currencyID;
  String _currencyName;
  String _currencySymbol;

  int get currencyID => _currencyID;

  set currencyID(int value) {
    _currencyID = value;
  }

  String get currencyName => _currencyName;

  String get currencySymbol => _currencySymbol;

  set currencySymbol(String value) {
    _currencySymbol = value;
  }

  set currencyName(String value) {
    _currencyName = value;
  }

  Map toMap() {
    Map map = {
      fieldCurrencyID: currencyID,
      fieldCurrencyName: currencyName,
      fieldCurrencySymbol: currencySymbol,
    };
    return map;
  }

  Currency();

  Currency.fromMap(Map map) {
    currencyID = map[fieldCurrencyID];
    currencyName = map[fieldCurrencyName];
    currencySymbol = map[fieldCurrencySymbol];
  }

  @override
  String createTableSQL() {
    return "CREATE TABLE ${tableName()} ("
        "$fieldCurrencyID INTEGER(2) NOT NULL,"
        "$fieldCurrencyName TEXT(5) NOT NULL,"
        "$fieldCurrencySymbol TEXT(5) NOT NULL,"
        "PRIMARY KEY ('$fieldCurrencyID')"
        ")";
  }

  static String tableName() => "t_currency";
  static String fieldCurrencyID = "currency_id";
  static String fieldCurrencyName = "currency_name";
  static String fieldCurrencySymbol = "currency_symbol";
}
