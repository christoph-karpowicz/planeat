import 'package:flutter/material.dart';
import 'package:planeat/db/ingredient_dao.dart';
import 'package:planeat/db/shopping_item_dao.dart';
import 'package:planeat/db/shopping_list_dao.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:planeat/dto/shopping_item_dto.dart';
import 'package:planeat/main.dart';
import 'package:planeat/model/ingredient.dart';
import 'package:planeat/utils/date_utils.dart';
import 'package:planeat/views/shopping_list_form.dart';


class ShoppingListNameInputDialog extends StatefulWidget {
  final List<MealItemDto> _selectedMeals;

  const ShoppingListNameInputDialog(this._selectedMeals,
                                    {Key? key}): super(key: key);

  @override
  _ShoppingListNameInputDialog createState() => _ShoppingListNameInputDialog();

}

class _ShoppingListNameInputDialog extends State<ShoppingListNameInputDialog> {
  TextEditingController _nameController = TextEditingController();
  bool _isNameError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('New shopping list'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(
            hintText: _isNameError ? "name cannot be empty" : "enter name...",
            hintStyle: TextStyle(
              color: _isNameError ? Colors.red : null,
            )
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            primary: Colors.white,
          ),
          child: Text('CANCEL'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            primary: Colors.white,
          ),
          child: Text('OK'),
          onPressed: () async {
            String name = _nameController.value.text.trim();

            if (name.isEmpty) {
              setState(() {
                _isNameError = true;
              });
              return;
            }
            setState(() {
              _isNameError = false;
            });

            List<Ingredient> allIngredients = <Ingredient>[];
            Map<String, ShoppingItemDto> allIngredientsAggregated = <String, ShoppingItemDto>{};

            for (MealItemDto mealDto in widget._selectedMeals) {
              List<Ingredient> ingredients = await IngredientDao.getByMealId(mealDto.mealId);
              allIngredients.addAll(ingredients);
            }

            allIngredients.forEach((ingredient) {
              final String name = ingredient.name.trim();
              final String quantity = ingredient.quantity.trim();
              ShoppingItemDto newItem = new ShoppingItemDto(quantity);
              if (allIngredientsAggregated[name] == null) {
                allIngredientsAggregated[name] = newItem;
              } else {
                ShoppingItemDto currentItem = allIngredientsAggregated[name]!;
                currentItem.merge(newItem);
              }
            });

            final int shoppingListId = await ShoppingListDao.save(name, getSqliteDateTime(DateTime.now()));
            allIngredientsAggregated.forEach((key, value) async {
              await ShoppingItemDao.save(shoppingListId, key, value.toString());
            });

            Navigator.pushNamed(
                context,
                ShoppingListFormView.routeName,
                arguments: ShoppingListFormViewArguments(
                    shoppingListId,
                    CalendarView.routeName)
            );
          },
        ),
      ],
    );
  }
}
