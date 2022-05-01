import 'package:flutter/material.dart';
import 'package:planeat/components/add_ingredient_button.dart';
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
  ValueNotifier<bool> _isEditable = ValueNotifier(false);
  Meal? _meal;
  String _mealName = "";
  TextEditingController _mealNameController = TextEditingController();
  TextEditingController _mealDescriptionController = TextEditingController();
  bool _showDescription = false;
  List<IngredientListItem> _ingredientItems = <IngredientListItem>[];
  List<int> _ingredientsToRemove = <int>[];

  @override
  void initState() {
    super.initState();
    int? mealId = this.widget.arg?.mealId;
    if (mealId != null) {
      _reloadForm();
    } else {
      setState(() {
        _createMode = true;
      });
    }
  }

  void _loadMeal(int mealId) async {
    Meal? meal = await MealDao.getById(mealId);
    if (meal != null) {
      _mealNameController.value = TextEditingValue(text: meal.name);
      _mealDescriptionController.value = TextEditingValue(text: meal.description);
      setState(() {
        _meal = meal;
        _mealName = meal.name;
      });
    }
  }

  void _loadIngredients(int mealId) async {
    List<Ingredient> ingredients = await IngredientDao.getByMealId(mealId);
    List<IngredientListItem> ingredientListItems = List.generate(
        ingredients.length,
        (index) => IngredientListItem(
          IngredientListItemState(),
          _removeIngredient,
          _isEditable,
          ingredients[index],
          key: Key(ingredients[index].id.toString())
        )
    );
    setState(() {
      _ingredientItems = ingredientListItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mealName),
        backgroundColor: Colors.lightGreen,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/meals'),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _isEditable,
        builder: (BuildContext context, bool editMode, Widget? child) {
          return SingleChildScrollView(
            child: Column(
              children: [

                // Meal name section
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
                          controller: _mealNameController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            enabled: editMode,
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  )
                ),

                // Meal description section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("Description: "),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              _showDescription ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                              color: _showDescription ? Colors.red : Colors.green),
                            onPressed: () {
                              setState(() {
                                _showDescription = !_showDescription;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: Visibility(
                    visible: _showDescription,
                    child: Container(
                      height: _showDescription ? null : 0,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  minLines: 6,
                                  maxLines: null,
                                  controller: _mealDescriptionController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    enabled: editMode,
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ),

                // Ingredients section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ingredients: "),
                      ],
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _ingredientItems.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == _ingredientItems.length) {
                        if (editMode) {
                          return AddIngredientButton(_addEmptyIngredient);
                        } else {
                          return SizedBox();
                        }
                      }

                      _ingredientItems[index] = _ingredientItems[index].clone();
                      return _ingredientItems[index];
                    },
                  )
                ),
              ],
            ),
          );
        }
      ),

      // Buttons
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _isEditable,
        builder: (BuildContext context, bool editMode, Widget? child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!editMode) Container(
                margin: _buttonMargin,
                child: FloatingActionButton(
                  onPressed: _onEdit,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.edit),
                ),
              ),
              if (editMode) Container(
                margin: _buttonMargin,
                child: FloatingActionButton(
                  onPressed: _onCancel,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.cancel),
                ),
              ),
              if (editMode) Container(
                margin: _buttonMargin,
                child: FloatingActionButton(
                  onPressed: _onSave,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.save),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  void _onEdit() {
    _isEditable.value = true;
  }

  void _exitEditMode() {
    _isEditable.value = false;
    setState(() {
      _ingredientsToRemove = <int>[];
    });
  }

  void _onCancel() {
    if (_createMode) {
      Navigator.pop(context);
    } else {
      _resetMealName();
      _exitEditMode();
      _reloadForm();
    }
  }

  void _onSave() async {
    if (this._meal != null) {
      await MealDao.update(this._meal!.id, _mealNameController.value.text, _mealDescriptionController.value.text);
      _ingredientItems.forEach((item) async {
        Ingredient ingredient = item.getItem();
        String name = item.getNameController().value.text;
        String quantity = item.getQuantityController().value.text;
        if (ingredient.id == 0) {
          await IngredientDao.save(this._meal!.id, name, quantity);
        } else {
          await IngredientDao.update(ingredient.id, name, quantity);
        }
      });
      _ingredientsToRemove.forEach((id) async => await IngredientDao.deleteById(id));

      _exitEditMode();
    }
    _reloadForm();
  }

  void _resetMealName() {
    _mealNameController.value = TextEditingValue(text: _meal!.name);
  }

  void _reloadForm() {
    int? mealId = this.widget.arg?.mealId;
    if (mealId != null) {
      _loadMeal(mealId);
      _loadIngredients(mealId);
    }
  }

  void _addEmptyIngredient() {
    setState(() {
      _ingredientItems.add(IngredientListItem(
          IngredientListItemState(),
          _removeIngredient,
          _isEditable,
          Ingredient(
              id: 0,
              name: "",
              quantity: ""),
          key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      ));
    });
  }

  void _removeIngredient(Key key) {
    print(key.toString());
    IngredientListItem idToRemove =
      _ingredientItems.firstWhere((item) => item.key == key);
    setState(() {
      _ingredientItems.removeWhere((item) => item.key == key);
      _ingredientsToRemove.add(idToRemove.getItem().id);
    });
  }
}
