import 'package:planeat/db/db_handler.dart';
import 'package:planeat/model/shopping_item.dart';

class ShoppingItemDao {

  static Future<List<ShoppingItem>> getByMealId(int shoppingListId) async {
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb()
        .rawQuery(
        'SELECT id, shopping_list_id, name, quantity, bought FROM shopping_item WHERE shopping_list_id = ?',
        <Object>[shoppingListId]
    );
    return List.generate(
        maps.length,
            (i) => ShoppingItem(
          id: maps[i]['id'],
          shoppingListId: maps[i]['shopping_list_id'],
          name: maps[i]['name'],
          quantity: maps[i]['quantity'],
          bought: maps[i]['bought'],
        )
    );
  }

  static Future<void> save(int shoppingListId, String name, String quantity) async {
    await DatabaseHandler.getDb().execute(
        "INSERT INTO shopping_item(shopping_list_id, name, quantity) VALUES (?, ?, ?)",
        <Object>[shoppingListId, name, quantity]
    );
  }

  static Future<void> update(int id, bool bought) async {
    await DatabaseHandler.getDb().execute(
        "UPDATE shopping_item SET bought = ? WHERE id = ?",
        <Object>[bought, id]
    );
  }

  static Future<void> deleteById(int id) async {
    await DatabaseHandler.getDb().execute(
        "DELETE FROM shopping_item WHERE id = ?",
        <Object>[id]
    );
  }

}
