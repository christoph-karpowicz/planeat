import 'package:planeat/db/db_handler.dart';
import 'package:planeat/model/meal.dart';

class MealDao {

  static Future<List<Meal>> loadAll() async {
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb().query('meal');
    return List.generate(
        maps.length,
            (i) => Meal(id: maps[i]['id'], name: maps[i]['name']));
  }

}
