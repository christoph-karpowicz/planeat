import 'package:flutter/material.dart';
import 'package:planeat/model/ingredient.dart';

class IngredientListItemWrapper {
  final Ingredient _item;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final bool _isEditable;
  final bool _isNameError;

  IngredientListItemWrapper(this._item,
                            this._isEditable,
                            this._isNameError);

  Ingredient get getItem {
    return _item;
  }

}
