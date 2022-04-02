import 'package:planeat/model/ingredient.dart';

class Meal {
  final int? id;
  final String name;
  final List<Ingredient> ingredients;

  Meal({
    this.id,
    required this.name,
    required this.ingredients,
  });

  Meal.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        ingredients = res["ingredients"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'ingredients': ingredients};
  }
}
