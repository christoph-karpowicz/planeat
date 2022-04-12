class Ingredient {
  final int id;
  final int? mealId;
  final String name;
  final String quantity;

  Ingredient({
    required this.id,
    this.mealId,
    required this.name,
    required this.quantity,
  });

  Ingredient.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        mealId = res["mealId"],
        name = res["name"],
        quantity = res["quantity"];

  Map<String, Object?> toMap() {
    return {'id': id, 'mealId': mealId, 'name': name, 'quantity': quantity};
  }
}
