import 'package:planeat/db/db_handler.dart';
import 'package:planeat/model/shopping_list.dart';

class ShoppingListDao {

  static Future<List<ShoppingList>> loadAll() async {
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb()
        .query('shopping_list');
    return List.generate(
        maps.length,
            (i) => ShoppingList(
              id: maps[i]['id'],
              name: maps[i]['name'],
              date: maps[i]['date'],
        )
    );
  }

  static Future<ShoppingList?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb()
        .rawQuery('SELECT id, name, date FROM shopping_list WHERE id = ?', <Object>[id]);
    final mealsCount = maps.length;
    if (mealsCount == 0) {
      return null;
    }

    return ShoppingList(
      id: maps[0]['id'],
      name: maps[0]['name'],
      date: maps[0]['date'],
    );
  }

  static Future<int> save(String name, String date) async {
    return await DatabaseHandler.getDb().insert("shopping_list", {
      "name": name,
      "date": date,
    });
  }

  static Future<void> deleteById(int id) async {
    await DatabaseHandler.getDb().execute(
        "DELETE FROM shopping_item WHERE shopping_list_id = ?",
        <Object>[id]
    );
    await DatabaseHandler.getDb().execute(
        "DELETE FROM shopping_list WHERE id = ?",
        <Object>[id]
    );
  }

}
