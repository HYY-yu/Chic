import 'package:chic/bean/db.dart';

class BillType extends SQLModel {
  int _typeID;
  String _typeName;
  String _typeIcon;
  int _typeFlag;

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName() ("
        "$fieldTypeID INTEGER(8) NOT NULL,"
        "$fieldTypeName TEXT(6) NOT NULL,"
        "$fieldTypeIcon TEXT(100) NOT NULL,"
        "$fieldTypeFlag INTEGER(1) NOT NULL,"
        "PRIMARY KEY ($fieldTypeID)"
        ")";
  }

  static String tableName() => "t_bill_type";
  static String fieldTypeID = "type_id";
  static String fieldTypeName = "type_name";
  static String fieldTypeIcon = "type_icon";
  static String fieldTypeFlag = "type_flag";

  int get typeID => _typeID;

  set typeID(int value) {
    _typeID = value;
  }

  String get typeName => _typeName;

  set typeName(String value) {
    _typeName = value;
  }

  String get typeIcon => _typeIcon;

  set typeIcon(String value) {
    _typeIcon = value;
  }

  int get typeFlag => _typeFlag;

  set typeFlag(int value) {
    _typeFlag = value;
  }
}
