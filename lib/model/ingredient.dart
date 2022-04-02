class Ingredient {
  final int? id;
  final int mealId;
  final String name;
  final String quantity;

  Ingredient({
    this.id,
    required this.mealId,
    required this.name,
    required this.quantity,
  });
}
