class Meal {
  final int id;
  final String name;
  final String description;
  final bool isDeleted;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.isDeleted,
  });

  Meal.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        description = res["description"],
        isDeleted = res["isDeleted"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isDeleted': isDeleted
    };
  }
}
