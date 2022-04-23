import 'package:flutter/material.dart';
import 'package:planeat/db/meal_item_dao.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:intl/intl.dart';

class MainMealStack extends StatefulWidget {
  final VoidCallback _reloadSelectedMeals;
  final MealItemDto _item;
  DateTime _selectedDay;

  MainMealStack(this._reloadSelectedMeals, this._item, this._selectedDay);

  @override
  _MainMealStackState createState() => _MainMealStackState();

}

class _MainMealStackState extends State<MainMealStack> {
  double _topLayerX = 0.0;
  bool _animation = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [

                // Edit button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0)
                      ),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () => {
                        _selectNewTime()
                      },
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),

                // Delete button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0)
                      ),
                      color: Colors.red,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () => {
                        MealItemDao.deleteById(this.widget._item.id),
                        this.widget._reloadSelectedMeals()
                      },
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
            height: 60.0,
          ),

          AnimatedContainer(
            onEnd: () => {
              _setAnimation(false)
            },
            duration: const Duration(milliseconds: 150),
            transform: Matrix4.translationValues(_topLayerX, 0, 0),
            height: 60.0,
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: ListTile(
              onTap: () => print('${this.widget._item}'),
              title: Text('${DateFormat('HH:mm:ss').format(this.widget._item.date)} | ${this.widget._item.name}'),
            ),
          ),
        ],
      ),

      onPanUpdate: (details) {
        // Swiping in right direction.
        if (details.delta.dx > 0) {
          _setTopLayerX(1);
        }
        // Swiping in left direction.
        if (details.delta.dx < 0) {
          _setTopLayerX(-1);
        }
      },
    );
  }

  void _setAnimation(bool isOn) {
    setState(() {
      _animation = isOn;
    });
  }

  void _setTopLayerX(int direction) {
    if (_animation) {
      return;
    }
    _setAnimation(true);
    double offset;
    if (_topLayerX == 0) {
      offset = direction * 50.0;
    } else {
      offset = 0.0;
    }
    setState(() {
      _topLayerX = offset;
    });
  }

  void _selectNewTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      final String selectedDayFormatted = DateFormat('yyyy-MM-dd').format(this.widget._selectedDay);
      final String newTimeHour = newTime.hour.toString().padLeft(2, "0");
      final String newTimeMinutes = newTime.minute.toString().padLeft(2, "0");
      String mealDate = "$selectedDayFormatted $newTimeHour:$newTimeMinutes:00.000Z";

      MealItemDao.update(this.widget._item.id, mealDate);
      this.widget._reloadSelectedMeals();
      _setTopLayerX(0);
    }
  }
}
