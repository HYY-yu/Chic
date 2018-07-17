import 'package:chic/bean/db.dart';

class BillType extends SQLModel {
  // 101 - 1999 系统定义  2000 - 2999 用户自定义
  int typeID;
  String typeName;
  int typeIcon;

  // 一级类别父id为0
  int parentTypeID;

  // 收入or支出 1 收入 0 支出
  int isIncome;

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName ("
        "$fieldTypeID INTEGER(8) NOT NULL,"
        "$fieldTypeName TEXT(6) NOT NULL,"
        "$fieldTypeIcon TEXT(100) NOT NULL,"
        "$fieldParentTypeID INTEGER(8) NOT NULL,"
        "$fieldIsIncome INTEGER(1) NOT NULL,"
        "PRIMARY KEY ($fieldTypeID)"
        ")";
  }

  static String tableName = "t_bill_type";
  static String fieldTypeID = "type_id";
  static String fieldTypeName = "type_name";
  static String fieldTypeIcon = "type_icon";
  static String fieldParentTypeID = "parent_type_id";
  static String fieldIsIncome = "type_is_income";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      fieldTypeID: typeID,
      fieldTypeName: typeName,
      fieldTypeIcon: typeIcon,
      fieldParentTypeID: parentTypeID,
      fieldIsIncome: isIncome,
    };
    return map;
  }

  BillType();

  BillType.fromMap(Map<String, dynamic> map) {
    typeID = map[fieldTypeID];
    typeName = map[fieldTypeName];
    typeIcon = map[fieldTypeIcon];
    parentTypeID = map[fieldParentTypeID];
    isIncome = map[fieldIsIncome];
  }
}
