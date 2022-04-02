class MealItem {
  final int id;
  final int mealId;
  final String date;

  MealItem({
    required this.id,
    required this.mealId,
    required this.date,
  });

  MealItem.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        mealId = res["mealId"],
        date = res["date"];

  Map<String, Object?> toMap() {
    return {'id': id, 'mealId': mealId, 'date': date};
  }

  @override
  String toString() {
    return 'MealItem{id: $id, mealId: $mealId, date: $date}';
  }
}
