import 'package:flutter/material.dart';
import 'package:planeat/components/ingredient_list_item.dart';
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
                ),
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
              ),
          ),
          Expanded(
            child: Column(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: _ingredients.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _ingredients.length) {
                              if (_isEditable()) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          _ingredients.add(Ingredient(
                                            id: 0,
                                            name: "",
                                            quantity: "")
                                          );
                                          setState(() {
                                            _ingredients = _ingredients;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.plus_one,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            }

                            return IngredientListItem(
                                _removeIngredient,
                                _isEditable(),
                                _ingredients[index],
                                key: Key(_ingredients[index].id.toString()));
                          },
                        )
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_isEditable()) Container(
            margin: _buttonMargin,
            child: FloatingActionButton(
              onPressed: () =>
                setState(() {
                  _editMode = true;
                }),
              backgroundColor: Colors.green,
              child: const Icon(Icons.edit),
            ),
          ),
          if (_isEditable()) Container(
            margin: _buttonMargin,
            child: FloatingActionButton(
              onPressed: _onCancel,
              backgroundColor: Colors.red,
              child: const Icon(Icons.cancel),
            ),
          ),
          if (_isEditable()) Container(
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

  void _onCancel() {
    if (_createMode) {
      Navigator.pop(context);
    } else {
      _resetMealName();
      setState(() {
        _editMode = false;
      });
      int? mealId = this._meal?.id;
      if (mealId != null) {
        _loadMeal(mealId);
        _loadIngredients(mealId);
      }
    }
  }

  void _resetMealName() {
    setState(() {
      _mealName = _meal!.name;
    });
  }

  void _removeIngredient(int id) {
    _ingredients.removeWhere((ingredient) => ingredient.id == id);
    setState(() {
      _ingredients = _ingredients;
    });
  }
}
