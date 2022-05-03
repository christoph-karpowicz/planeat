import 'package:flutter/material.dart';
import 'package:planeat/components/meal_list_item.dart';
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
    _loadMeals();
  }

  void _loadMeals() async {
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
                    return MealListItem(
                        _loadMeals,
                        items[index],
                        key: Key(items[index].id.toString()));
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
          onPressed: () =>
            Navigator.pushNamed(
                context,
                MealFormView.routeName,
                arguments: MealFormViewArguments(null, MealsView.routeName)
            ),
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
