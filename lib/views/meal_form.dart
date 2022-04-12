import 'package:flutter/material.dart';
import 'package:planeat/db/meal_dao.dart';
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
  bool _createMode = false;
  bool _editMode = false;
  Meal? _meal;
  String _mealName = "";

  @override
  void initState() {
    super.initState();
    int? mealId = this.widget.arg?.mealId;
    if (mealId != null) {
      loadMeal(mealId);
    } else {
      setState(() {
        _createMode = true;
      });
    }
  }

  void loadMeal(int mealId) async {
    Meal? meal = await MealDao.getById(mealId);
    if (meal != null) {
      setState(() {
        _meal = meal;
        _mealName = meal.name;
      });
    }
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
                      labelText: _isEditable() ? 'enter the meal name' : null,
                      enabled: _isEditable(),
                    ),
                  ),
                  flex: 2,
                )
              ],
            )
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_editMode && !_createMode) Container(
            margin: EdgeInsets.only(left: 3.0, right: 3.0),
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
            margin: EdgeInsets.only(left: 3.0, right: 3.0),
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
            margin: EdgeInsets.only(left: 3.0, right: 3.0),
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
