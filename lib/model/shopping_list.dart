class ShoppingList {
  final int id;
  final String date;

  ShoppingList({
    required this.id,
    required this.date,
  });

  ShoppingList.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        date = res["date"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date,
    };
  }
}
