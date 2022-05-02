import 'package:flutter/material.dart';
import 'package:planeat/model/ingredient.dart';

class IngredientListItemController {
  final Ingredient item;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final bool isEditable;
  bool isNameError;
  final bool isNew;

  IngredientListItemController(this.item,
                            this.isEditable,
                            this.isNameError,
                            this.isNew) {
    nameController.value = TextEditingValue(text: item.name);
    quantityController.value = TextEditingValue(text: item.quantity);
  }

}
