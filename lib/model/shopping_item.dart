class ShoppingItem {
  final int id;
  final int shoppingListId;
  final String name;
  final String quantity;
  final bool bought;

  ShoppingItem({
    required this.id,
    required this.shoppingListId,
    required this.name,
    required this.quantity,
    required this.bought,
  });

  ShoppingItem.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        shoppingListId = res["shoppingListId"],
        name = res["name"],
        quantity = res["quantity"],
        bought = res["bought"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'shoppingListId': shoppingListId,
      'name': name,
      'quantity': quantity,
      'bought': bought,
    };
  }
}
