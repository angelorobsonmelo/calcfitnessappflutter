import 'package:execflutter/helpers/sql_helper.dart';
import 'package:execflutter/model/fitness.dart';
import 'package:sqflite/sqflite.dart';

class FitnessDao {
  SqlHelper _sqlHelper = SqlHelper();

  static final FitnessDao instance = FitnessDao.internal();

  factory FitnessDao() => instance;

  FitnessDao.internal();

  Future<Fitness> save(Fitness fitness) async {
    Database db = await _sqlHelper.db;
    fitness.id = await db.insert(SqlHelper.calcTable, fitness.toMap());

    return fitness;
  }

  Future<List> getAll(String type) async {
    Database db = await _sqlHelper.db;
    List listMap = await db.rawQuery(
        "SELECT * FROM ${SqlHelper.calcTable} WHERE type_calc = '$type'");
    List<Fitness> listFitness = List();
    for (Map m in listMap) {
      listFitness.add(Fitness.fromMap(m));
    }

    return listFitness;
  }
}
