import 'package:flutter/material.dart';
import 'package:planeat/db/ingredient_dao.dart';
import 'package:planeat/db/meal_dao.dart';
import 'package:planeat/model/ingredient.dart';
import 'package:planeat/model/meal.dart';

class MealFormViewArguments {
  final int? mealId;

  MealFormViewArguments(this.mealId);
}

class MealFormView extends StatefulWidget {
  static const routeName = '/meal_form';
  final MealFormViewArguments? arg;

  const MealFormView({Key? key, this.arg}): super(key: key);

  @override
  _MealFormViewState createState() => _MealFormViewState();

}

class _MealFormViewState extends State<MealFormView> {
  final EdgeInsets _buttonMargin = EdgeInsets.only(left: 3.0, right: 3.0);

  bool _createMode = false;
  bool _editMode = false;
  Meal? _meal;
  String _mealName = "";
  List<Ingredient> _ingredients = <Ingredient>[];

  @override
  void initState() {
    super.initState();
    int? mealId = this.widget.arg?.mealId;
    if (mealId != null) {
      _loadMeal(mealId);
      _loadIngredients(mealId);
    } else {
      setState(() {
        _createMode = true;
      });
    }
  }

  void _loadMeal(int mealId) async {
    Meal? meal = await MealDao.getById(mealId);
    if (meal != null) {
      setState(() {
        _meal = meal;
        _mealName = meal.name;
      });
    }
  }

  void _loadIngredients(int mealId) async {
    List<Ingredient> ingredients = await IngredientDao.getByMealId(mealId);
    print(ingredients);
    setState(() {
      _ingredients = ingredients;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_meal == null) {
    //   return Scaffold(
    //       body: Center(child: CircularProgressIndicator())
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(_mealName),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text("Meal name: "),
                  flex: 1,
                ),
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: _mealName),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      enabled: _isEditable(),
                    ),
                  ),
                  flex: 2,
                )
              ],
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Ingredients: "),
                ],
              )
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      final int ingredientId = _ingredients[index].id;
                      final String ingredientName = _ingredients[index].name;
                      final String ingredientQuantity = _ingredients[index].quantity;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: TextEditingController(text: ingredientName),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: _isEditable() ? 'ingredient name' : null,
                                  enabled: _isEditable(),
                                ),
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: TextEditingController(text: ingredientQuantity),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: _isEditable() ? 'quantity' : null,
                                  enabled: _isEditable(),
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_editMode && !_createMode) Container(
            margin: _buttonMargin,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _editMode = true;
                });
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.edit),
            ),
          ),
          if (_editMode || _createMode) Container(
            margin: _buttonMargin,
            child: FloatingActionButton(
              onPressed: () {
                if (_createMode) {
                  Navigator.pop(context);
                } else {
                  _resetMealName();
                  setState(() {
                    _editMode = false;
                  });
                }
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.cancel),
            ),
          ),
          if (_editMode || _createMode) Container(
            margin: _buttonMargin,
            child: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }

  bool _isEditable() {
    return _editMode || _createMode;
  }

  void _resetMealName() {
    setState(() {
      _mealName = _meal!.name;
    });
  }
}
