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

  static void update(int id, String mealDate) async {
    await DatabaseHandler.getDb().execute(
        "UPDATE meal_item SET date = ? WHERE id = ?",
        <Object>[mealDate, id]
    );
  }

  static Future<List<MealItemDto>> loadAllFromDay(DateTime date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb().rawQuery(
        "SELECT meal_item.id, meal.id as meal_id, meal.name, meal.description, meal_item.date "
            "FROM meal_item INNER JOIN meal ON meal_item.meal_id = meal.id "
            "WHERE strftime('%Y-%m-%d', meal_item.date) = ?",
        <String>[dateFormatted]);

    List<MealItemDto> mealsForDay = List.generate(maps.length, (i) => MealItemDto(
      id: maps[i]['id'],
      mealId: maps[i]['meal_id'],
      name: maps[i]['name'],
      description: maps[i]['description'],
      date: DateTime.parse(maps[i]['date']),
    ));
    mealsForDay.sort((a,b) => a.date.compareTo(b.date));

    return mealsForDay;
  }

  static Future<Map<String, List<MealItemDto>>> loadAndMapFrom3Months(DateTime date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    final List<Map<String, dynamic>> maps = await DatabaseHandler.getDb().rawQuery(
        "SELECT meal_item.id, meal.id as meal_id, meal.name, meal.description, meal_item.date, strftime('%Y-%m-%d', meal_item.date) as date_key "
            "FROM meal_item INNER JOIN meal ON meal_item.meal_id = meal.id "
            "WHERE date(?) BETWEEN date(meal_item.date, '-50 days') AND date(meal_item.date, '+50 days')",
        <String>[dateFormatted]);

    Map<String, List<MealItemDto>> mappedMeals = {};
    maps.forEach((meal) {
      if (mappedMeals[meal['date_key']] == null) {
        mappedMeals[meal['date_key']] = <MealItemDto>[];
      }
      mappedMeals[meal['date_key']]!.add(MealItemDto(
        id: meal['id'],
        mealId: meal['meal_id'],
        name: meal['name'],
        description: meal['description'],
        date: DateTime.parse(meal['date']),
      ));
    });

    mappedMeals.forEach((key, value) {
      value.sort((a,b) => a.date.compareTo(b.date));
    });

    return mappedMeals;
  }

  static void deleteById(int id) async {
    await DatabaseHandler.getDb().execute(
        "DELETE FROM meal_item WHERE id = ?",
        <Object>[id]
    );
  }

}
