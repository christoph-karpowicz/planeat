import 'package:flutter/material.dart';
import 'package:planeat/model/shopping_item.dart';

class ShoppingListItemController {
  final ShoppingItem item;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final bool isEditable;
  bool isNameError;
  final bool isNew;

  ShoppingListItemController(this.item,
      this.isEditable,
      this.isNameError,
      this.isNew) {
    nameController.value = TextEditingValue(text: item.name);
    quantityController.value = TextEditingValue(text: item.quantity);
  }

}
