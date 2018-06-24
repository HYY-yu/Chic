import 'package:chic/bean/billtype.dart';
import 'package:chic/bean/db.dart';
import 'package:chic/bean/budget.dart';

class Bill extends SQLModel {
  String billID;
  String budgetID;
  double billAmount;
  int billTypeID;
  int createDateTime;

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

   Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      fieldBillID: billID,
      fieldBudgetID: budgetID,
      fieldBillAmount: billAmount,
      fieldBillTypeID: billTypeID,
      fieldCreateDateTime: createDateTime,
    };
    return map;
  }

  Bill();

  Bill.fromMap(Map<String, dynamic> map) {
    billID = map[fieldBillID];
    budgetID = map[fieldBudgetID];
    billAmount = map[fieldBillAmount];
    billTypeID = map[fieldBillTypeID];
    createDateTime = map[fieldCreateDateTime];
  }
}
