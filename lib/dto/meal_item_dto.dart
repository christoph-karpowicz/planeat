class MealItemDto {
  final int id;
  final String name;
  final String description;
  final DateTime date;

  MealItemDto({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
  });

  MealItemDto.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        description = res["description"],
        date = res["date"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': description, 'description': name, 'date': date};
  }

  @override
  String toString() {
    return 'MealItemDto{id: $id, name: $name, description: $description, date: $date}';
  }
}
