import 'package:planeat/db/db_handler.dart';
import 'package:planeat/model/ingredient.dart';

class IngredientDao {

  static Future<List<Ingredient>> getByMealId(int mealId) async {
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb()
        .rawQuery(
          'SELECT id, name, quantity FROM ingredient WHERE meal_id = ?',
          <Object>[mealId]
        );
    return List.generate(
        maps.length,
            (i) => Ingredient(
                id: maps[i]['id'],
                name: maps[i]['name'],
                quantity: maps[i]['quantity'],
            )
        );
  }

  static Future<void> save(int mealId, String name, String quantity) async {
    await DatabaseHandler.getDb().execute(
        "INSERT INTO ingredient(meal_id, name, quantity) VALUES (?, ?, ?)",
        <Object>[mealId, name, quantity]
    );
  }

  static Future<void> update(int id, String name, String quantity) async {
    await DatabaseHandler.getDb().execute(
        "UPDATE ingredient SET name = ?, quantity = ? WHERE id = ?",
        <Object>[name, quantity, id]
    );
  }

  static Future<void> deleteById(int id) async {
    await DatabaseHandler.getDb().execute(
        "DELETE FROM ingredient WHERE id = ?",
        <Object>[id]
    );
  }

}
