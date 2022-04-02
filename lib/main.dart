import 'package:flutter/material.dart';
import 'package:planeat/db/db_handler.dart';
import 'package:planeat/model/meal_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

late Database db;

Future<void> main() async {
  print("Start app.");
  try {
    runApp(PlaneatApp());
    db = await DatabaseHandler().initializeDB();
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
  late final ValueNotifier<List<MealItem>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  // _CalendarViewState(Database db) {
  //   this.db = db;
  // }

  @override
  void initState() {
    super.initState();

    // _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(<MealItem>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TableCalendar<MealItem>(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
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
            Expanded(
              child: ValueListenableBuilder<List<MealItem>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
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
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index].mealId}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = await _getEventsForDay(selectedDay);
    }
  }

  Future<List<MealItem>> _getEventsForDay(DateTime date) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    print(dateFormatted);
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT meal.name, meal_item.date '
        'FROM meal_item INNER JOIN meal ON meal_item.meal_id = meal.id');
    print(maps);
    return <MealItem>[MealItem(id: 1, mealId: 1, date: DateTime.now())];
  }
}
