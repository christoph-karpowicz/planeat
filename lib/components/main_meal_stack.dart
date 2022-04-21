import 'package:flutter/material.dart';
import 'package:planeat/db/meal_item_dao.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:intl/intl.dart';

class MainMealStack extends StatefulWidget {
  final VoidCallback _reloadSelectedMeals;
  final MealItemDto _item;

  MainMealStack(this._reloadSelectedMeals, this._item);

  @override
  _MainMealStackState createState() => _MainMealStackState();

}

class _MainMealStackState extends State<MainMealStack> {
  double _dragStartX = 0.0;
  double _topLayerX = 0.0;

  // @override
  // void initState() {
  //   super.initState();
  //   loadMeals();
  // }

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

        Container(
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

      onHorizontalDragStart: (details) => {
        _setDragStartX(details.globalPosition.dx)
      },
      onHorizontalDragUpdate: (details) => {
        _setTopLayerX(details.globalPosition.dx)
      },
    );
  }

  void _setDragStartX(double startX) {
    setState(() {
      _dragStartX = startX;
    });
  }

  void _setTopLayerX(double x) {
    double offset = x - _dragStartX;
    if (offset.abs() <= 50.0) {
      setState(() {
        _topLayerX = offset;
      });
    }
  }
}
