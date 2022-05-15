class ShoppingList {
  final int id;
  final String name;
  final DateTime date;

  ShoppingList({
    required this.id,
    required this.name,
    required this.date,
  });

  ShoppingList.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        date = res["date"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
    };
  }
}
