class Meal {
  final int id;
  final String name;

  Meal({
    required this.id,
    required this.name,
  });

  Meal.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }
}
