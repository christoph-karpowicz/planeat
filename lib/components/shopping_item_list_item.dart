import 'package:flutter/material.dart';
import 'package:planeat/model/shopping_item.dart';

class ShoppingItemListItem extends StatefulWidget {
  final void Function(int) _removeShoppingItem;
  final bool _isEditable;
  final bool _isNameError;
  final ShoppingItem _item;
  final TextEditingController _nameController;
  final TextEditingController _quantityController;

  ShoppingItemListItem(this._removeShoppingItem,
      this._isEditable,
      this._isNameError,
      this._item,
      this._nameController,
      this._quantityController,
      {Key? key}): super(key: key);

  @override
  _ShoppingItemListItemState createState() => _ShoppingItemListItemState();

}

class _ShoppingItemListItemState extends State<ShoppingItemListItem> {
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
                        // MealItemDao.deleteById(widget._item.id),
                        // widget._reloadSelectedMeals()
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
                widget._removeShoppingItem(widget._item.id);
                _setAnimation(false);
              },
              duration: const Duration(milliseconds: 180),
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
                        controller: widget._nameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: widget._isNameError ? Colors.red : Colors.grey,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: widget._isNameError ? Colors.red : Colors.grey,
                                width: 2.0,
                              )
                          ),
                          labelText: widget._isEditable ?
                          (widget._isNameError ? 'name cannot be empty' : 'name') : null,
                          labelStyle: TextStyle(
                            color: widget._isNameError ? Colors.red : Colors.green,
                          ),
                          enabled: widget._isEditable,
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: widget._quantityController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              )
                          ),
                          labelText: widget._isEditable ? 'quantity' : null,
                          labelStyle: TextStyle(
                              color: Colors.green
                          ),
                          enabled: widget._isEditable,
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
    if (_animation || !widget._isEditable) {
      return;
    }
    _setAnimation(true);
    setState(() {
      _topLayerX = -50.0;
    });
  }

}
