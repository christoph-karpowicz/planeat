import 'package:flutter/material.dart';
import 'package:planeat/db/meal_item_dao.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:intl/intl.dart';
import 'package:planeat/main.dart';
import 'package:planeat/views/meal_form.dart';

class MainMealListItem extends StatefulWidget {
  final void Function(DateTime) _reloadSelectedMeals;
  final MealItemDto _item;
  DateTime _selectedDay;
  final bool _isRange;
  final bool _isFirstFromDay;

  MainMealListItem(
      this._reloadSelectedMeals,
      this._item,
      this._selectedDay,
      this._isRange,
      this._isFirstFromDay,
      {Key? key}): super(key: key);

  @override
  _MainMealListItemState createState() => _MainMealListItemState();

}

class _MainMealListItemState extends State<MainMealListItem> {
  static final double HEIGHT = 60.0;

  double _topLayerX = 0.0;
  bool _animation = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          if (widget._isRange && widget._isFirstFromDay) Container(
            margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    '${DateFormat('dd/MM/yyyy').format(this.widget._item.date)}',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Divider(
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: 6.0,
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
                            this.widget._reloadSelectedMeals(widget._selectedDay)
                          },
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),
                height: HEIGHT,
              ),

              AnimatedContainer(
                onEnd: () => {
                  _setAnimation(false)
                },
                duration: const Duration(milliseconds: 90),
                transform: Matrix4.translationValues(_topLayerX, 0, 0),
                height: HEIGHT,
                margin: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: 6.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                      context,
                      MealFormView.routeName,
                      arguments: MealFormViewArguments(
                          widget._item.mealId,
                          CalendarView.routeName)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: HEIGHT,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, size: 30.0,),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${DateFormat('HH:mm').format(this.widget._item.date)}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        )
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: HEIGHT,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.grey)
                            ),
                          ),
                          child: Text(
                            '${this.widget._item.name}',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ],
      ),

      onPanUpdate: (details) {
        // Swiping in right direction.
        if (details.delta.dx > 5 && _topLayerX <= 0) {
          _setTopLayerX(1);
        }
        // Swiping in left direction.
        if (details.delta.dx < -5 && _topLayerX >= 0) {
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
      initialTime: TimeOfDay.fromDateTime(widget._item.date),
    );
    if (newTime != null) {
      final String selectedDayFormatted = DateFormat('yyyy-MM-dd').format(this.widget._selectedDay);
      final String newTimeHour = newTime.hour.toString().padLeft(2, "0");
      final String newTimeMinutes = newTime.minute.toString().padLeft(2, "0");
      String mealDate = "$selectedDayFormatted $newTimeHour:$newTimeMinutes:00.000Z";

      MealItemDao.update(this.widget._item.id, mealDate);
      this.widget._reloadSelectedMeals(widget._selectedDay);
      _setTopLayerX(0);
    }
  }
}
