import 'package:chic/bean/billtype.dart';
import 'package:chic/bean/db.dart';
import 'package:chic/bean/budget.dart';

class Bill extends SQLModel {
  String _billID;
  String _budgetID;
  double _billAmount;
  int _billTypeID;
  int _createDateTime;

  @override
  String createTableSQL() {
    return "CREATE TABLE $tableName ("
        "$fieldBillID INTEGER NOT NULL,"
        "$fieldBudgetID INTEGER(8) NOT NULL,"
        "$fieldBillAmount REAL(10,2) NOT NULL,"
        "$fieldBillTypeID INTEGER(8) NOT NULL,"
        "$fieldCreateDateTime INTEGER(20) NOT NULL,"
        "PRIMARY KEY ($fieldBillID) ,"
        "CONSTRAINT 'fk_bill_budget' FOREIGN KEY ($fieldBudgetID) "
        "REFERENCES ${Budget.tableName} (${Budget.fieldBudgetID}) "
        "ON DELETE RESTRICT ON UPDATE CASCADE,"
        "CONSTRAINT 'fk_bill_type' FOREIGN KEY ($fieldBillTypeID) "
        "REFERENCES ${BillType.tableName} (${BillType.fieldTypeID}) "
        "ON DELETE RESTRICT ON UPDATE CASCADE"
        ")";
  }

  static String tableName = "t_bill";
  static String fieldBillID = "bill_id";
  static String fieldBudgetID = "budget_id";
  static String fieldBillAmount = "bill_amount";
  static String fieldBillTypeID = "type_id";
  static String fieldCreateDateTime = "create_datetime";

   Map toMap() {
    Map map = {
      fieldBillID: billID,
      fieldBudgetID: budgetID,
      fieldBillAmount: billAmount,
      fieldBillTypeID: billTypeID,
      fieldCreateDateTime: createDateTime,
    };
    return map;
  }

  Bill();

  Bill.fromMap(Map map) {
    billID = map[fieldBillID];
    budgetID = map[fieldBudgetID];
    billAmount = map[fieldBillAmount];
    billTypeID = map[fieldBillTypeID];
    createDateTime = map[fieldCreateDateTime];
  }

  int get createDateTime => _createDateTime;

  set createDateTime(int value) {
    _createDateTime = value;
  }

  int get billTypeID => _billTypeID;

  set billTypeID(int value) {
    _billTypeID = value;
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
