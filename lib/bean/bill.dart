import 'package:chic/bean/billtype.dart';
import 'package:chic/bean/db.dart';
import 'package:chic/bean/budget.dart';

class Bill extends SQLModel {
  String _billID;
  String _budgetID;
  double _billAmount;
  int _typeID;
  int _createDateTime;

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName() ("
        "$fieldBillID INTEGER NOT NULL,"
        "$fieldBudgetID INTEGER(8) NOT NULL,"
        "$fieldBillAmount REAL(10,2) NOT NULL,"
        "$fieldBillTypeID INTEGER(8) NOT NULL,"
        "$fieldCreateDateTime INTEGER(20) NOT NULL,"
        "PRIMARY KEY ($fieldBillID) ,"
        "CONSTRAINT 'fk_bill_budget' FOREIGN KEY ($fieldBudgetID) "
        "REFERENCES ${Budget.tableName()} (${Budget.fieldBudgetID}) "
        "ON DELETE RESTRICT ON UPDATE CASCADE,"
        "CONSTRAINT 'fk_bill_type' FOREIGN KEY ($fieldBillTypeID) "
        "REFERENCES ${BillType.tableName()} (${BillType.fieldTypeID}) "
        "ON DELETE RESTRICT ON UPDATE CASCADE"
        ")";
  }

  static String fieldBillID = "bill_id";
  static String fieldBudgetID = "budget_id";
  static String fieldBillAmount = "bill_amount";
  static String fieldBillTypeID = "type_id";
  static String fieldCreateDateTime = "create_datetime";

  String tableName() => "t_bill";

  int get createDateTime => _createDateTime;

  set createDateTime(int value) {
    _createDateTime = value;
  }

  int get typeID => _typeID;

  set typeID(int value) {
    _typeID = value;
  }

  double get billAmount => _billAmount;

  set billAmount(double value) {
    _billAmount = value;
  }

  String get budgetID => _budgetID;

  set budgetID(String value) {
    _budgetID = value;
  }

  String get billID => _billID;

  set billID(String value) {
    _billID = value;
  }
}
