import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print("Database path: $path");
    return await openDatabase(
      join(path, 'planeat.db'),
      onConfigure: (db) async {
        print("Initializing database...");
        // await db.execute("DROP TABLE IF EXISTS meal");
        // await db.execute("DROP TABLE IF EXISTS ingredient");
        // await db.execute("DROP TABLE IF EXISTS meal_item");

        bool tablesCreated = false;
        try {
          await db.execute(
            "CREATE TABLE meal(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)",
          );
          await db.execute(
            "CREATE TABLE ingredient(id INTEGER PRIMARY KEY AUTOINCREMENT, meal_id INTEGER, name TEXT NOT NULL, quantity TEXT NOT NULL, FOREIGN KEY (meal_id) REFERENCES meal (id))",
          );
          await db.execute(
            "CREATE TABLE meal_item(id INTEGER PRIMARY KEY AUTOINCREMENT, meal_id INTEGER NOT NULL, date TEXT NOT NULL, FOREIGN KEY (meal_id) REFERENCES meal (id))",
          );
          tablesCreated = true;
        }
        catch (e) {
          print("Databse already initialized.");
        }

        if (!tablesCreated) {
          return;
        }

        await db.execute(
          "INSERT INTO meal(name) VALUES ('owsianka')",
        );
        await db.execute(
          "INSERT INTO meal(name) VALUES ('pyszny ryż z ciecierzycą')",
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
          "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='owsianka'), '2022-04-01 08:00:00.000Z')",
        );
        await db.execute(
          "INSERT INTO meal_item(meal_id, date) VALUES ((SELECT id FROM meal WHERE name='pyszny ryż z ciecierzycą'), '2022-04-01 15:00:00.000Z')",
        );
        print("Database initialized.");
      },
      version: 1,
    );
  }

}
