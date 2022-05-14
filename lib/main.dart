import 'package:flutter/material.dart';
import 'package:planeat/components/calendar_meal_marker.dart';
import 'package:planeat/components/main_meal_list_item.dart';
import 'package:planeat/components/nav.dart';
import 'package:planeat/components/nav_icons.dart';
import 'package:planeat/components/shopping_list_name_input_dialog.dart';
import 'package:planeat/db/db_handler.dart';
import 'package:planeat/db/meal_dao.dart';
import 'package:planeat/db/meal_item_dao.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:planeat/model/meal.dart';
import 'package:planeat/utils/date_utils.dart';
import 'package:planeat/views/meal_form.dart';
import 'package:planeat/views/meals_view.dart';
import 'package:planeat/views/shopping_list_form.dart';
import 'package:planeat/views/shopping_lists_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  print("Start app.");
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await DatabaseHandler.initializeDB();
    runApp(PlaneatApp());
  } catch (err) {
    print(err.toString());
  }
}

class PlaneatApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planeat',
      initialRoute: CalendarView.routeName,
      routes: {
        CalendarView.routeName: (context) => CalendarView(),
        MealsView.routeName: (context) => MealsView(),
        ShoppingListsView.routeName: (context) => ShoppingListsView(),
      },
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          MealFormView.routeName: (context) =>
              MealFormView(arg: settings.arguments as MealFormViewArguments),
          ShoppingListFormView.routeName: (context) =>
              ShoppingListFormView(arg: settings.arguments as ShoppingListFormViewArguments),
        };
        WidgetBuilder? builder = routes[settings.name];
        if (builder == null) {
          return null;
        }
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}

class CalendarView extends StatefulWidget {
  static const routeName = '/calendar';

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final ValueNotifier<List<MealItemDto>> _selectedMeals = ValueNotifier(<MealItemDto>[]);
  final ValueNotifier<List<Meal>> _availableMeals = ValueNotifier(<Meal>[]);
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Key _markersKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    print("Init state...");
    _loadMeals();
  }

  void _loadMeals() async {
    _availableMeals.value = await MealDao.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 8.0),
          Stack(
            children: [
              TableCalendar<MealItemDto>(
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                rangeSelectionMode: _rangeSelectionMode,
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
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (<int>[DateTime.saturday, DateTime.sunday].contains(day.weekday)) {
                      final text = DateFormat.E().format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                  markerBuilder: (context, day, meals) {
                    return CalendarMealMarker(
                        day,
                        key: _markersKey
                    );
                  }
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: Visibility(
                      visible: _rangeSelectionMode == RangeSelectionMode.toggledOn,
                      child: FloatingActionButton(
                        heroTag: "crslist",
                        onPressed: _displayShoppingListNameInputDialog,
                        // onPressed: () async {
                        //   // await ShoppingListDao.save(DateTime.now());
                        // },
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.shopping_cart),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: ValueListenableBuilder<List<MealItemDto>>(
                valueListenable: _selectedMeals,
                builder: (context, items, _) {
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      MealItemDto item = items[index];
                      return MainMealListItem(
                          _reloadSelectedMeals,
                          item,
                          item.date,
                          _rangeSelectionMode == RangeSelectionMode.toggledOn,
                          index == 0 || items[index - 1].date.day != items[index].date.day,
                          key: Key(item.id.toString()));
                    },
                    shrinkWrap: true,
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  margin: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  height: 60,
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
                            onTap: () => _selectMealTime(mealId),
                          );
                        },
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Nav(NavIcon.calendar),
        ],
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
    });
    _reloadSelectedMeals(_selectedDay!);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) async {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
    if (start != null && end != null) {
      _selectedMeals.value = await MealItemDao.loadAllFromRange(start, end);
      setState(() {
        _markersKey = UniqueKey();
      });
    } else if (start != null && end == null) {
      _selectedMeals.value = await MealItemDao.loadAllFromDay(start);
      setState(() {
        _markersKey = UniqueKey();
      });
    }
  }

  void _selectMealTime(int mealId) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime == null) {
      return;
    }

    bool isStartRange = _rangeSelectionMode == RangeSelectionMode.toggledOn && _rangeStart != null && _rangeEnd == null;
    final String newTimeHour = newTime.hour.toString().padLeft(2, "0");
    final String newTimeMinutes = newTime.minute.toString().padLeft(2, "0");

    if (_rangeSelectionMode == RangeSelectionMode.toggledOff || isStartRange) {
      DateTime selectedDay = isStartRange ? _rangeStart! : _selectedDay!;
      final String selectedDayFormatted = DateFormat('yyyy-MM-dd').format(selectedDay);
      String mealDate = getSqliteDate(selectedDayFormatted, newTimeHour, newTimeMinutes);

      MealItemDao.save(mealId, mealDate);
      _reloadSelectedMeals(selectedDay);
    }
    if (_rangeSelectionMode == RangeSelectionMode.toggledOn && _rangeStart != null && _rangeEnd != null) {
      int dayDiff = _rangeEnd!.difference(_rangeStart!).inDays;
      List<DateTime> days = List.generate(dayDiff + 1, (i) => DateTime(_rangeStart!.year, _rangeStart!.month, _rangeStart!.day + i));
      days.forEach((day) {
        final String selectedDayFormatted = DateFormat('yyyy-MM-dd').format(day);
        String mealDate = getSqliteDate(selectedDayFormatted, newTimeHour, newTimeMinutes);

        MealItemDao.save(mealId, mealDate);
      });
      _reloadSelectedMeals(null);
    }
  }

  void _reloadSelectedMeals(DateTime? day) async {
    if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
      _selectedMeals.value = await MealItemDao.loadAllFromRange(_rangeStart!, _rangeEnd!);
    } else if (_rangeSelectionMode == RangeSelectionMode.toggledOff) {
      _selectedMeals.value = await MealItemDao.loadAllFromDay(day!);
    }
    setState(() {
      _markersKey = UniqueKey();
    });
  }

  Future<void> _displayShoppingListNameInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return ShoppingListNameInputDialog(_selectedMeals.value);
      },
    );
  }

  @override
  void dispose() {
    _selectedMeals.dispose();
    super.dispose();
  }

}
