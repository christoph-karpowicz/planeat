class MealItemDto {
  final int id;
  final String name;
  final DateTime date;

  MealItemDto({
    required this.id,
    required this.name,
    required this.date,
  });

  MealItemDto.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        date = res["date"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'date': date};
  }

  @override
  String toString() {
    return 'MealItemDto{id: $id, name: $name, date: $date}';
  }
}
