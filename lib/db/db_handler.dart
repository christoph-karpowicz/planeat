import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {

  Future<Database> initializeDB() async {
    print("Opening database...");
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'planeat.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE meal(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)",
        );
        await database.execute(
          "CREATE TABLE ingredient(id INTEGER PRIMARY KEY AUTOINCREMENT, meal_id INTEGER, name TEXT NOT NULL, quantity TEXT NOT NULL, FOREIGN KEY (meal_id) REFERENCES meal (id))",
        );
        await database.execute(
          "CREATE TABLE meal_item(id INTEGER PRIMARY KEY AUTOINCREMENT, meal_id INTEGER NOT NULL, date TEXT NOT NULL, FOREIGN KEY (meal_id) REFERENCES meal (id))",
        );
      },
      version: 1,
    );
  }

}
