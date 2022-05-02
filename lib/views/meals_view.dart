import 'package:flutter/material.dart';
import 'package:planeat/components/nav.dart';
import 'package:planeat/components/nav_icons.dart';
import 'package:planeat/db/meal_dao.dart';
import 'package:planeat/model/meal.dart';
import 'package:planeat/views/meal_form.dart';

class MealsView extends StatefulWidget {
  static const routeName = '/meals';

  @override
  _MealsViewState createState() => _MealsViewState();

}

class _MealsViewState extends State<MealsView> {
  final ValueNotifier<List<Meal>> _availableMeals = ValueNotifier(<Meal>[]);

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  void loadMeals() async {
    List<Meal> allMeals = await MealDao.loadAll();
    _availableMeals.value = allMeals.where((meal) => !meal.isDeleted).toList();
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
            child: ValueListenableBuilder<List<Meal>>(
              valueListenable: _availableMeals,
              builder: (context, items, _) {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final int mealId = items[index].id;
                    final String mealName = items[index].name;

                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black38))
                        ),
                        child: Text(
                          mealName,
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(
                          context,
                          MealFormView.routeName,
                          arguments: MealFormViewArguments(mealId)
                      ),
                    );
                  },
                  shrinkWrap: true,
                );
              }
            ),
          ),
          Nav(NavIcon.meals),
        ]
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
                context,
                MealFormView.routeName,
                arguments: MealFormViewArguments(null)
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
