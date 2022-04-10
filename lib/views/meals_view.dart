import 'package:flutter/material.dart';
import 'package:planeat/components/nav.dart';
import 'package:planeat/components/nav_icons.dart';
import 'package:planeat/db/meal_dao.dart';
import 'package:planeat/model/meal.dart';

class MealsView extends StatefulWidget {

  @override
  _MealsViewState createState() => _MealsViewState();

}

class _MealsViewState extends State<MealsView> {
  List<Meal> availableMeals = <Meal>[];

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  void loadMeals() async {
    availableMeals = await MealDao.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Expanded(
            // Within the `FirstScreen` widget
            child: ListView.builder(
              itemCount: availableMeals.length,
              itemBuilder: (context, index) {
                final int mealId = availableMeals[index].id;
                final String mealName = availableMeals[index].name;

                return InkWell(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                    ),
                    margin: EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Text(
                      mealName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () => {},
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Nav(NavIcon.meals),
        ]
      ),
    );
  }
}
