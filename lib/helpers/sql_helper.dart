import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class SqlHelper {
  static final SqlHelper instance = SqlHelper.internal();

  static final String calcTable = "calc";
  static final String idColumn = "id";
  static final String typeCalcColumn = "type_calc";
  static final String resultColumn = "res";
  static final String createdAtColumn = "created_date";

  factory SqlHelper() => instance;

  SqlHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final dataBasesPath = await getDatabasesPath();
    final path = join(dataBasesPath, "fitness_flutter.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $calcTable ($idColumn INTEGER PRIMARY KEY, "
          "$typeCalcColumn TEXT, $resultColumn DECIMAL, $createdAtColumn DATETIME)");
    });
  }

  Future close() async {
    Database dbFitness = await db;
    dbFitness.close();
  }
}
