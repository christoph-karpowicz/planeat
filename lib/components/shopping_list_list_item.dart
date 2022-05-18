import 'package:flutter/material.dart';
import 'package:planeat/db/shopping_list_dao.dart';
import 'package:planeat/model/shopping_list.dart';
import 'package:planeat/views/shopping_list_form.dart';
import 'package:planeat/views/shopping_lists_view.dart';
import 'package:intl/intl.dart';

class ShoppingListListItem extends StatefulWidget {
  final VoidCallback _reload;
  final ShoppingList _item;

  ShoppingListListItem(
      this._reload,
      this._item,
      {Key? key}): super(key: key);

  @override
  _ShoppingListListItemState createState() => _ShoppingListListItemState();

}

class _ShoppingListListItemState extends State<ShoppingListListItem> {
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
                              ShoppingListFormView.routeName,
                              arguments: ShoppingListFormViewArguments(
                                  widget._item.id,
                                  ShoppingListsView.routeName)
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
                      onPressed: () async {
                        await ShoppingListDao.deleteById(this.widget._item.id);
                        this.widget._reload();
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
                border: Border.all(
                  color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: InkWell(
                onTap: () => Navigator.pushNamed(
                    context,
                    ShoppingListFormView.routeName,
                    arguments: ShoppingListFormViewArguments(
                        widget._item.id,
                        ShoppingListsView.routeName)
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget._item.name,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          '${DateFormat('dd/MM/yyy HH:mm:ss').format(widget._item.date)}',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontStyle: FontStyle.italic,
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
