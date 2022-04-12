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

}
