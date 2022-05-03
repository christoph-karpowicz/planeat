import 'package:flutter/material.dart';
import 'package:planeat/db/meal_dao.dart';
import 'package:planeat/model/meal.dart';
import 'package:planeat/views/meal_form.dart';
import 'package:planeat/views/meals_view.dart';

class MealListItem extends StatefulWidget {
  final VoidCallback _reload;
  final Meal _item;

  MealListItem(
      this._reload,
      this._item,
      {Key? key}): super(key: key);

  @override
  _MealListItemState createState() => _MealListItemState();

}

class _MealListItemState extends State<MealListItem> {
  static final double HEIGHT = 60.0;

  double _topLayerX = 0.0;
  bool _animation = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 6.0,
              left: 12.0,
              right: 12.0,
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
                      onPressed: () =>
                        Navigator.pushNamed(
                            context,
                            MealFormView.routeName,
                            arguments: MealFormViewArguments(
                                widget._item.id,
                                MealsView.routeName)
                        ),
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
                        MealDao.deleteById(this.widget._item.id),
                        this.widget._reload()
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
                top: 6.0,
                left: 12.0,
                right: 12.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: InkWell(
                onTap: () => Navigator.pushNamed(
                    context,
                    MealFormView.routeName,
                    arguments: MealFormViewArguments(
                        widget._item.id,
                        MealsView.routeName)
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        widget._item.name,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
}
