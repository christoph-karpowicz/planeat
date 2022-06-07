import 'package:flutter/material.dart';
import 'package:planeat/components/meal_list_item.dart';
import 'package:planeat/components/nav.dart';
import 'package:planeat/components/nav_icons.dart';
import 'package:planeat/db/meal_dao.dart';
import 'package:planeat/main.dart';
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
    _availableMeals.value = await MealDao.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, CalendarView.routeName),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // Within the `FirstScreen` widget
            child: ValueListenableBuilder<List<Meal>>(
              valueListenable: _availableMeals,
              builder: (context, items, _) {
                if (items.length > 0) {
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
                } else {
                  return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                        "there are no meals to choose from",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        )
                    ),
                  );
                }
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
