import 'package:flutter/material.dart';
import 'package:planeat/db/meal_item_dao.dart';
import 'package:planeat/dto/meal_item_dto.dart';

class CalendarMealMarker extends StatefulWidget {
  final DateTime _day;

  const CalendarMealMarker(this._day, {Key? key}): super(key: key);

  @override
  _CalendarMealMarker createState() => _CalendarMealMarker();

}

class _CalendarMealMarker extends State<CalendarMealMarker> {
  List<MealItemDto> _mealList = <MealItemDto>[];

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  void _loadMeals() async {
    List<MealItemDto> mealList = await MealItemDao.loadAllFromDay(widget._day);
    setState(() {
      _mealList = mealList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mealList.length == 0) {
      return SizedBox();
    }

    List<Widget> markers = List.generate(
        _mealList.length,
        (index) => Container(
          margin: EdgeInsets.all(1.0),
          width: 4.0,
          height: 4.0,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ));

    return Container(
      child: Wrap(
        children: markers,
      ),
    );
  }
}
