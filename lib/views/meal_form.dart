import 'package:flutter/material.dart';
import 'package:planeat/components/nav.dart';
import 'package:planeat/components/nav_icons.dart';
import 'package:planeat/db/meal_dao.dart';
import 'package:planeat/model/meal.dart';

class MealFormViewArguments {
  final int mealId;

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
  late Meal? _meal = null;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  void loadMeal() async {
    int? mealId = this.widget.arg?.mealId;
    if (mealId == null) {
      return;
    }
    Meal? meal = await MealDao.getById(mealId);
    setState(() {
      _meal = meal;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_meal == null) {
      return Scaffold(
          body: Center(child: CircularProgressIndicator())
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_meal!.name),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
          children: [
            Expanded(
              child: Text("test")
            ),
          ]
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
