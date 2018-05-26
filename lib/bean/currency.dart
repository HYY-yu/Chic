import 'dart:async';

import 'package:chic/bean/db.dart';
import 'package:sqflite/sqflite.dart';

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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      fieldCurrencyID: currencyID,
      fieldCurrencyName: currencyName,
      fieldCurrencySymbol: currencySymbol,
    };
    return map;
  }

  Currency();

  Currency.newCurrency(
      this._currencyID, this._currencyName, this._currencySymbol);

  Currency.fromMap(Map<String, dynamic> map) {
    currencyID = map[fieldCurrencyID];
    currencyName = map[fieldCurrencyName];
    currencySymbol = map[fieldCurrencySymbol];
  }

  static Future<void> initCurrencyTable(Database db) async {
    List<Currency> currencyList = new List();

    Currency c1 = Currency.newCurrency(1, "人民币", "RMB");
    Currency c2 = Currency.newCurrency(2, "美元", "US");
    Currency c3 = Currency.newCurrency(3, "港币", "HK");
    Currency c4 = Currency.newCurrency(4, "澳元", "MOP");
    Currency c5 = Currency.newCurrency(5, "日元", "JPY");
    Currency c6 = Currency.newCurrency(6, "韩元", "KRW");
    Currency c7 = Currency.newCurrency(7, "新台币", "NT");

    currencyList.add(c1);
    currencyList.add(c2);
    currencyList.add(c3);
    currencyList.add(c4);
    currencyList.add(c5);
    currencyList.add(c6);
    currencyList.add(c7);

    await _insertCurrencys(db, currencyList);
  }

  static Future<void> _insertCurrencys(
      Database db, List<Currency> currencys) async {
    var batch = db.batch();
    currencys.forEach((elem) {
      batch.insert(tableName, elem.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
    });
    await batch.commit(noResult: true);
  }

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName ("
        "$fieldCurrencyID INTEGER(2) NOT NULL,"
        "$fieldCurrencyName TEXT(5) NOT NULL,"
        "$fieldCurrencySymbol TEXT(5) NOT NULL,"
        "PRIMARY KEY ('$fieldCurrencyID')"
        ")";
  }

  static String tableName = "t_currency";
  static String fieldCurrencyID = "currency_id";
  static String fieldCurrencyName = "currency_name";
  static String fieldCurrencySymbol = "currency_symbol";
}
