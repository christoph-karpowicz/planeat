import 'package:flutter/material.dart';
import 'package:planeat/db/shopping_item_dao.dart';
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
  bool _isBought = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isBought = widget._item.bought;
    });
  }

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
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 30.0,
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
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey.shade300,
                            )
                          )
                        ),
                        child: TextFormField(
                          controller: widget._nameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5.0),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget._isNameError ? Colors.red : Colors.grey.shade300,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget._isNameError ? Colors.red : Colors.grey.shade300,
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
                      ),
                      flex: 6,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: widget._quantityController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5.0),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
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
                      flex: 4,
                    ),
                    if (!widget._isEditable) Expanded(
                      child: IconButton(
                        icon: Icon(Icons.done_outline),
                        color: _isBought ? Colors.green : Colors.grey.shade300,
                        iconSize: 40.0,
                        onPressed: () async {
                          await ShoppingItemDao.updateBought(widget._item.id, _isBought ? "FALSE" : "TRUE");
                          setState(() => _isBought = !_isBought);
                        },
                      ),
                      flex: 2,
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
