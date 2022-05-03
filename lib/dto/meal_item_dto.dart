class MealItemDto {
  final int id;
  final int mealId;
  final String name;
  final String description;
  final DateTime date;

  MealItemDto({
    required this.id,
    required this.mealId,
    required this.name,
    required this.description,
    required this.date,
  });

  MealItemDto.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        mealId = res["meal_id"],
        name = res["name"],
        description = res["description"],
        date = res["date"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'meal_id': mealId,
      'name': description,
      'description': name,
      'date': date
    };
  }

}
