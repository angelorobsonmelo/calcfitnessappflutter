import 'package:execflutter/helpers/sql_helper.dart';
import 'package:intl/intl.dart';

final String calcTable = "calc";
final String idColumn = "id";
final String typeCalcColumn = "type_calc";
final String resultColumn = "res";
final String createdAtColumn = "created_date";

class Fitness {
  int id;
  String typeCalc;
  double res;
  String createdAt;

  Fitness();

  Fitness.full(this.typeCalc, this.res, this.createdAt);

  Fitness.fromMap(Map map) {
    id = map[SqlHelper.idColumn];
    typeCalc = map[SqlHelper.typeCalcColumn];
    res = map[SqlHelper.resultColumn];
    res = double.parse(res.toStringAsFixed(2));
    createdAt = map[SqlHelper.createdAtColumn];
    DateTime dateTime = DateTime.parse(createdAt);
    createdAt = new DateFormat("dd/MM/yyyy HH:mm").format(dateTime);
  }

  Map toMap() {
    Map<String, dynamic> map = {
      SqlHelper.typeCalcColumn: typeCalc,
      SqlHelper.resultColumn: res,
      SqlHelper.createdAtColumn: createdAt
    };

    if (id != null) {
      map[SqlHelper.idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Fitness{id: $id, typeCalc: $typeCalc, res: $res, createdAt: $createdAt}';
  }
}
