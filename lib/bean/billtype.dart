import 'package:chic/bean/db.dart';

class BillType extends SQLModel {
  // 1001 - 1999 系统定义  2000 - 2999 用户自定义
  int _typeID;
  String _typeName;
  String _typeIcon;
  int _typeFlag;

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName ("
        "$fieldTypeID INTEGER(8) NOT NULL,"
        "$fieldTypeName TEXT(6) NOT NULL,"
        "$fieldTypeIcon TEXT(100) NOT NULL,"
        "$fieldTypeFlag INTEGER(1) NOT NULL,"
        "PRIMARY KEY ($fieldTypeID)"
        ")";
  }

  static String tableName = "t_bill_type";
  static String fieldTypeID = "type_id";
  static String fieldTypeName = "type_name";
  static String fieldTypeIcon = "type_icon";
  static String fieldTypeFlag = "type_flag";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      fieldTypeID: typeID,
      fieldTypeName: typeName,
      fieldTypeIcon: typeIcon,
      fieldTypeFlag: typeFlag,
    };
    return map;
  }

  BillType();

  BillType.fromMap(Map<String, dynamic> map) {
    typeID = map[fieldTypeID];
    typeName = map[fieldTypeName];
    typeIcon = map[fieldTypeIcon];
    typeFlag = map[fieldTypeFlag];
  }

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
