import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {

  static late Database _db;

  static Future<void> initializeDB() async {
    String path = await getDatabasesPath();
    print("Database path: $path");
    _db = await openDatabase(
      join(path, 'planeat.db'),
      onConfigure: (db) async {
        print("Initializing database...");
        // await db.execute("DROP TABLE IF EXISTS meal");
        // await db.execute("DROP TABLE IF EXISTS ingredient");
        // await db.execute("DROP TABLE IF EXISTS meal_item");
        // await db.execute("DROP TABLE IF EXISTS shopping_list");
        // await db.execute("DROP TABLE IF EXISTS shopping_item");

        bool tablesCreated = false;
        try {
          await db.execute(
            "CREATE TABLE meal(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "name TEXT NOT NULL, "
                "description TEXT NOT NULL DEFAULT '', "
                "is_deleted BOOLEAN NOT NULL DEFAULT FALSE)",
          );
          await db.execute(
            "CREATE TABLE ingredient(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "meal_id INTEGER, "
                "name TEXT NOT NULL, "
                "quantity TEXT NOT NULL, "
                "FOREIGN KEY (meal_id) REFERENCES meal (id))",
          );
          await db.execute(
            "CREATE TABLE meal_item(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "meal_id INTEGER NOT NULL, "
                "date TEXT NOT NULL, "
                "FOREIGN KEY (meal_id) REFERENCES meal (id))",
          );
          await db.execute(
            "CREATE TABLE shopping_list(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "name TEXT NOT NULL, "
                "date TEXT NOT NULL)",
          );
          await db.execute(
            "CREATE TABLE shopping_item(id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "shopping_list_id INTEGER NOT NULL, "
                "name TEXT NOT NULL, "
                "quantity TEXT NOT NULL, "
                "bought BOOLEAN NOT NULL DEFAULT FALSE, "
                "FOREIGN KEY (shopping_list_id) REFERENCES shopping_list (id))",
          );
          tablesCreated = true;
        } catch (e) {
          print("Database already initialized.");
        }

        if (!tablesCreated) {
          return;
        }

        // await db.execute(
        //   "INSERT INTO meal(name, description) VALUES ('owsianka', 'testowy opis')",
        // );
        // await db.execute(
        //   "INSERT INTO meal(name) VALUES ('pyszny ry?? z ciecierzyc??')",
        // );
        // await db.execute(
        //   "INSERT INTO meal(name) VALUES ('kanapki')",
        // );
        // await db.execute(
        //   "INSERT INTO meal(name) VALUES ('kotlety')",
        // );
        // await db.execute(
        //   "INSERT INTO meal(name) VALUES ('curry')",
        // );
        // await db.execute(
        //   "INSERT INTO meal(name) VALUES ('fasola po breto??sku')",
        // );
        // await db.execute(
        //   "INSERT INTO meal(name) VALUES ('sa??atka jarzynowa')",
        // );
        // await db.execute(
        //   "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='owsianka'), 'mleko', '50ml')",
        // );
        // await db.execute(
        //   "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='owsianka'), 'p??atki owsiane', '150g')",
        // );
        // await db.execute(
        //   "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='owsianka'), 'mas??o orzechowe', '90g')",
        // );
        // await db.execute(
        //   "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='kanapki'), 'bu??ki', '2szt')",
        // );
        // await db.execute(
        //   "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='owsianka'), '2022-05-03 08:00:00.000Z')",
        // );
        // await db.execute(
        //   "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='pyszny ry?? z ciecierzyc??'), '2022-05-03 15:00:00.000Z')",
        // );
        // await db.execute(
        //   "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='owsianka'), '2022-05-03 18:00:00.000Z')",
        // );
        // await db.execute(
        //   "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='kanapki'), '2022-05-03 20:00:00.000Z')",
        // );
        print("Database initialized.");
      },
      version: 1,
    );
  }

  static Database getDb() {
    return _db;
  }

}
