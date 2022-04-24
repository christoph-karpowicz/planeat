import 'package:flutter/material.dart';
import 'package:planeat/model/ingredient.dart';

class IngredientListItem extends StatefulWidget {
  final void Function(int) _removeIngredient;
  bool _isEditable;
  final Ingredient _item;

  IngredientListItem(
      this._removeIngredient,
      this._isEditable,
      this._item,
      {Key? key}): super(key: key);

  @override
  _IngredientListItem createState() => _IngredientListItem();

}

class _IngredientListItem extends State<IngredientListItem> {
  static final double HEIGHT = 60.0;

  double _topLayerX = 0.0;
  bool _animation = false;

  @override
  Widget build(BuildContext context) {
    final int? ingredientId = this.widget._item.id;
    final String ingredientName = this.widget._item.name;
    final String ingredientQuantity = this.widget._item.quantity;

    return GestureDetector(
      child: Stack(
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
                // Delete button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: Colors.red,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () => {
                        // MealItemDao.deleteById(this.widget._item.id),
                        // this.widget._reloadSelectedMeals()
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
              onEnd: () {
                this.widget._removeIngredient(this.widget._item.id);
                _setAnimation(false);
                // setState(() {
                //   _topLayerX = 0;
                // });
              },
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.translationValues(_topLayerX, 0, 0),
              height: HEIGHT,
              margin: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                bottom: 6.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: TextEditingController(text: ingredientName),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: this.widget._isEditable ? 'ingredient name' : null,
                          enabled: this.widget._isEditable,
                        ),
                        // onChanged: (e) {
                        //   print(e);
                        // },
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: TextEditingController(text: ingredientQuantity),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: this.widget._isEditable ? 'quantity' : null,
                          enabled: this.widget._isEditable,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              )
          ),
        ],
      ),

      onPanUpdate: (details) {
        // Swiping in left direction.
        if (details.delta.dx < -5 && _topLayerX >= 0) {
          _setTopLayerX();
        }
      },
    );
  }

  void _setAnimation(bool isOn) {
    setState(() {
      _animation = isOn;
    });
  }

  void _setTopLayerX() {
    if (_animation || !this.widget._isEditable) {
      return;
    }
    _setAnimation(true);
    setState(() {
      _topLayerX = -50.0;
    });
  }

}
