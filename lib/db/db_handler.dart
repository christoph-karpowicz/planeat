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

        bool tablesCreated = false;
        try {
          await db.execute(
            "CREATE TABLE meal(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL DEFAULT '')",
          );
          await db.execute(
            "CREATE TABLE ingredient(id INTEGER PRIMARY KEY AUTOINCREMENT, meal_id INTEGER, name TEXT NOT NULL, quantity TEXT NOT NULL, FOREIGN KEY (meal_id) REFERENCES meal (id))",
          );
          await db.execute(
            "CREATE TABLE meal_item(id INTEGER PRIMARY KEY AUTOINCREMENT, meal_id INTEGER NOT NULL, date TEXT NOT NULL, FOREIGN KEY (meal_id) REFERENCES meal (id))",
          );
          tablesCreated = true;
        } catch (e) {
          print("Database already initialized.");
        }

        if (!tablesCreated) {
          return;
        }

        await db.execute(
          "INSERT INTO meal(name, description) VALUES ('owsianka', 'testowy opis')",
        );
        await db.execute(
          "INSERT INTO meal(name) VALUES ('pyszny ryż z ciecierzycą')",
        );
        await db.execute(
          "INSERT INTO meal(name) VALUES ('kanapki')",
        );
        await db.execute(
          "INSERT INTO meal(name) VALUES ('kotlety')",
        );
        await db.execute(
          "INSERT INTO meal(name) VALUES ('curry')",
        );
        await db.execute(
          "INSERT INTO meal(name) VALUES ('fasola po bretońsku')",
        );
        await db.execute(
          "INSERT INTO meal(name) VALUES ('sałatka jarzynowa')",
        );
        await db.execute(
          "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='owsianka'), 'mleko', '50ml')",
        );
        await db.execute(
          "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='owsianka'), 'płatki owsiane', '150g')",
        );
        await db.execute(
          "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='owsianka'), 'masło orzechowe', '90g')",
        );
        await db.execute(
          "INSERT INTO ingredient(meal_id, name, quantity) VALUES ((SELECT id FROM meal WHERE name='kanapki'), 'bułki', '2szt')",
        );
        await db.execute(
          "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='owsianka'), '2022-04-01 08:00:00.000Z')",
        );
        await db.execute(
          "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='pyszny ryż z ciecierzycą'), '2022-04-01 15:00:00.000Z')",
        );
        await db.execute(
          "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='owsianka'), '2022-04-01 18:00:00.000Z')",
        );
        await db.execute(
          "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='kanapki'), '2022-04-01 20:00:00.000Z')",
        );
        print("Database initialized.");
      },
      version: 1,
    );
  }

  static Database getDb() {
    return _db;
  }

}
