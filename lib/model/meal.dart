class Meal {
  final int id;
  final String name;
  final String description;

  Meal({
    required this.id,
    required this.name,
    required this.description,
  });

  Meal.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        description = res["description"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
