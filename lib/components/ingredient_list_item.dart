import 'package:flutter/material.dart';
import 'package:planeat/model/ingredient.dart';

class IngredientListItem extends StatefulWidget {
  final IngredientListItemState state;
  final void Function(int) _removeIngredient;
  final ValueNotifier<bool> _isEditable;
  final Ingredient _item;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  IngredientListItem(this.state,
                     this._removeIngredient,
                     this._isEditable,
                     this._item,
                     {Key? key}): super(key: key) {
    _nameController.value = TextEditingValue(text: this._item.name);
    _quantityController.value = TextEditingValue(text: this._item.quantity);
  }

  @override
  IngredientListItemState createState() => this.state;

  Ingredient getItem() {
    return _item;
  }

  TextEditingController getNameController() {
    return _nameController;
  }

  TextEditingController getQuantityController() {
    return _quantityController;
  }

}

class IngredientListItemState extends State<IngredientListItem> {
  static final double HEIGHT = 60.0;

  double _topLayerX = 0.0;
  bool _animation = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: this.widget._isEditable,
      builder: (BuildContext context, bool editMode, Widget? child) {
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
                            controller: this.widget._nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: editMode ? 'ingredient name' : null,
                              enabled: editMode,
                            ),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: this.widget._quantityController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: editMode ? 'quantity' : null,
                              enabled: editMode,
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
    );
  }

  void _setAnimation(bool isOn) {
    setState(() {
      _animation = isOn;
    });
  }

  void _setTopLayerX() {
    if (_animation || !this.widget._isEditable.value) {
      return;
    }
    _setAnimation(true);
    setState(() {
      _topLayerX = -50.0;
    });
  }

}
