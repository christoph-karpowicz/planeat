class MealItemDto {
  final String name;
  final DateTime date;

  MealItemDto({
    required this.name,
    required this.date,
  });

  MealItemDto.fromMap(Map<String, dynamic> res)
      : name = res["name"],
        date = res["date"];

  Map<String, Object?> toMap() {
    return {'name': name, 'date': date};
  }

  @override
  String toString() {
    return 'MealItemDto{name: $name, date: $date}';
  }
}
