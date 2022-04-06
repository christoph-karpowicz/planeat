import 'package:flutter/material.dart';
import 'package:planeat/db/db_handler.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:planeat/model/meal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

late Database db;

Future<void> main() async {
  print("Start app.");
  try {
    WidgetsFlutterBinding.ensureInitialized();
    db = await DatabaseHandler().initializeDB();
    runApp(PlaneatApp());
  } catch (err) {
    print(err.toString());
  }
}

class PlaneatApp extends StatelessWidget {
  // late Database db;
  //
  // PlaneatApp(Database db, {Key? key}) : super(key: key) {
  //   this.db = db;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planeat',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CalendarView(),
    );
  }
}

class CalendarView extends StatefulWidget {
  // late Database db;
  //
  // CalendarView(Database db, {Key? key}) : super(key: key) {
  //   this.db = db;
  // }

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  // late Database db;
  late final ValueNotifier<List<MealItemDto>> _selectedMeals;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Meal> availableMeals = <Meal>[];

  // _CalendarViewState(Database db) {
  //   this.db = db;
  // }

  @override
  void initState() {
    super.initState();

    loadMeals();

    _selectedDay = _focusedDay;
    _selectedMeals = ValueNotifier(<MealItemDto>[]);
  }

  void loadMeals() async {
    final List<Map<String, dynamic>> maps = await db.query('meal');
    availableMeals = List.generate(
        maps.length,
        (i) => Meal(id: maps[i]['id'], name: maps[i]['name']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TableCalendar<MealItemDto>(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2032, 1, 1),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              headerVisible: true,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(height: 8.0),
            Container(
              child: ValueListenableBuilder<List<MealItemDto>>(
                valueListenable: _selectedMeals,
                builder: (context, items, _) {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      MealItemDto item = items[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => print('${item}'),
                          title: Text('${DateFormat('HH:mm:ss').format(item.date)} | ${item.name}'),
                        ),
                      );
                    },
                    shrinkWrap: true,
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(child: Container(
                  margin: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  height: 60,
                  child: ListView.builder(
                    itemCount: availableMeals.length,
                    itemBuilder: (context, index) {
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
                            color: Colors.orange,
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
                        onTap: () {
                          print("Tapped on container $mealName");
                        },
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  ),
                )
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ConstrainedBox(
            //       constraints: BoxConstraints.tightFor(height: 50),
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             textStyle: const TextStyle(fontSize: 20),
            //             primary: Colors.blueGrey
            //         ),
            //         onPressed: () {},
            //         child: const Text('Add meal'),
            //       ),
            //     ),
            //   ]
            // ),
            Expanded(child: const SizedBox(),)
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedMeals.value = await _getMealsForDay(selectedDay);
    }
  }

  Future<List<MealItemDto>> _getMealsForDay(DateTime date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT meal.name, meal_item.date "
        "FROM meal_item INNER JOIN meal ON meal_item.meal_id = meal.id "
        "WHERE strftime('%Y-%m-%d', meal_item.date) = ?",
        <String>[dateFormatted]);

    List<MealItemDto> mealsForDay = List.generate(maps.length, (i) => MealItemDto(
      name: maps[i]['name'],
      date: DateTime.parse(maps[i]['date']),
    ));
    mealsForDay.sort((a,b) => a.date.compareTo(b.date));

    return mealsForDay;
  }
}
