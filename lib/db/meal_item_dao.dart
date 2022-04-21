import 'package:planeat/db/db_handler.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:intl/intl.dart';

class MealItemDao {

  static void save(int mealId, String mealDate) async {
    await DatabaseHandler.getDb().execute(
        "INSERT INTO meal_item(meal_id, date) VALUES (?, ?)",
        <Object>[mealId, mealDate]
    );
  }

  static Future<List<MealItemDto>> loadAllFromDay(DateTime date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb().rawQuery(
        "SELECT meal_item.id, meal.name, meal_item.date "
            "FROM meal_item INNER JOIN meal ON meal_item.meal_id = meal.id "
            "WHERE strftime('%Y-%m-%d', meal_item.date) = ?",
        <String>[dateFormatted]);

    List<MealItemDto> mealsForDay = List.generate(maps.length, (i) => MealItemDto(
      id: maps[i]['id'],
      name: maps[i]['name'],
      date: DateTime.parse(maps[i]['date']),
    ));
    mealsForDay.sort((a,b) => a.date.compareTo(b.date));

    return mealsForDay;
  }

  static void deleteById(int id) async {
    await DatabaseHandler.getDb().execute(
        "DELETE FROM meal_item WHERE id = ?",
        <Object>[id]
    );
  }

}
