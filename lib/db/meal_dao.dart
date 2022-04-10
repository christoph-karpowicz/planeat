import 'package:planeat/db/db_handler.dart';
import 'package:planeat/model/meal.dart';

class MealDao {

  static Future<List<Meal>> loadAll() async {
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb().query('meal');
    return List.generate(
        maps.length,
            (i) => Meal(id: maps[i]['id'], name: maps[i]['name']));
  }

  static Future<Meal?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb().rawQuery('SELECT id, name FROM meal WHERE id = ?', <Object>[id]);
    final mealsCount = maps.length;
    if (mealsCount == 0) {
      return null;
    }
    return Meal(id: maps[0]['id'], name: maps[0]['name']);
  }

}
