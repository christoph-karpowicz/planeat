import 'package:flutter/material.dart';
import 'package:planeat/components/add_ingredient_button.dart';
import 'package:planeat/components/shopping_item_list_item.dart';
import 'package:planeat/components/shopping_list_item_controller.dart';
import 'package:planeat/db/shopping_item_dao.dart';
import 'package:planeat/db/shopping_list_dao.dart';
import 'package:planeat/model/shopping_item.dart';
import 'package:planeat/model/shopping_list.dart';

class ShoppingListFormViewArguments {
  final int? shoppingListId;
  final String fromRoute;

  ShoppingListFormViewArguments(this.shoppingListId, this.fromRoute);
}

class ShoppingListFormView extends StatefulWidget {
  static const routeName = '/shopping_list_form';
  final ShoppingListFormViewArguments? arg;

  const ShoppingListFormView({Key? key, this.arg}): super(key: key);

  @override
  _ShoppingListFormViewState createState() => _ShoppingListFormViewState();

}

class _ShoppingListFormViewState extends State<ShoppingListFormView> {
  final EdgeInsets _buttonMargin = EdgeInsets.only(left: 3.0, right: 3.0);

  ValueNotifier<bool> _isEditable = ValueNotifier(false);
  ShoppingList? _shoppingList;
  String _shoppingListName = "";
  bool _isShoppingListNameError = false;
  TextEditingController _shoppingListNameController = TextEditingController();
  List<ShoppingListItemController> _listItems = <ShoppingListItemController>[];
  List<int> _listItemsToRemove = <int>[];

  @override
  void initState() {
    super.initState();
    int? shoppingListId = this.widget.arg?.shoppingListId;
    if (shoppingListId != null) {
      _reloadForm(shoppingListId);
    }
  }

  void _loadMeal(int shoppingListId) async {
    ShoppingList? shoppingList = await ShoppingListDao.getById(shoppingListId);
    if (shoppingList != null) {
      _shoppingListNameController.value = TextEditingValue(text: shoppingList.name);
      setState(() {
        _shoppingList = shoppingList;
        _shoppingListName = shoppingList.name;
      });
    }
  }

  void _loadListItems(int shoppingListId) async {
    List<ShoppingItem> listItems = await ShoppingItemDao.getByShoppingListId(shoppingListId);
    List<ShoppingListItemController> listItemControllers = List.generate(
        listItems.length,
            (index) => ShoppingListItemController(
          listItems[index],
          false,
          false,
          false,
        )
    );
    setState(() => _listItems = listItemControllers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_shoppingListName),
        backgroundColor: Colors.lightGreen,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, widget.arg!.fromRoute),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamed(context, widget.arg!.fromRoute);
          return true;
        },
        child: ValueListenableBuilder(
            valueListenable: _isEditable,
            builder: (BuildContext context, bool editMode, _) {
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [

                    // Shopping list name section
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40.0,
                                alignment: Alignment.bottomLeft,
                                child: Text("Shopping list name: "),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _shoppingListNameController,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _isShoppingListNameError ? Colors.red : Colors.grey,
                                          width: 2.0,
                                        )
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: _isShoppingListNameError ? Colors.red : Colors.grey,
                                        )
                                    ),
                                    enabled: editMode,
                                    labelText: _isShoppingListNameError ? "shopping list name cannot be empty" : "",
                                    labelStyle: TextStyle(
                                        color: _isShoppingListNameError ? Colors.red : null
                                    )
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        )
                    ),

                    // Shopping items section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Items: "),
                        ],
                      ),
                    ),
                    if (_listItems.length > 0 || editMode) Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _listItems.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == _listItems.length) {
                              if (editMode) {
                                return AddIngredientButton(_addEmptyListItem);
                              } else {
                                return SizedBox();
                              }
                            }

                            return ShoppingItemListItem(
                                _removeListItem,
                                _isEditable.value,
                                _listItems[index].isNameError,
                                _listItems[index].item,
                                _listItems[index].nameController,
                                _listItems[index].quantityController,
                                key: Key(_listItems[index].item.id.toString())
                            );
                          },
                        )
                    ),
                    if (_listItems.length == 0 && !editMode) Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "there are no items on this list",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                        )
                    ),
                  ],
                ),
              );
            }
        ),
      ),

      // Buttons
      floatingActionButton: ValueListenableBuilder(
          valueListenable: _isEditable,
          builder: (BuildContext context, bool editMode, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!editMode) Container(
                  margin: _buttonMargin,
                  child: FloatingActionButton(
                    heroTag: "slfedit",
                    onPressed: _onEdit,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.edit),
                  ),
                ),
                if (editMode) Container(
                  margin: _buttonMargin,
                  child: FloatingActionButton(
                    heroTag: "slfcancel",
                    onPressed: _onCancel,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.cancel),
                  ),
                ),
                if (editMode) Container(
                  margin: _buttonMargin,
                  child: FloatingActionButton(
                    heroTag: "slfsave",
                    onPressed: _onSave,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.save),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }

  void _onEdit() {
    _isEditable.value = true;
  }

  void _exitEditMode() {
    _isEditable.value = false;
    setState(() => _listItemsToRemove = <int>[]);
  }

  void _onCancel() {
    _resetShoppingListName();
    _exitEditMode();
    _reloadForm(this.widget.arg?.shoppingListId);
  }

  void _onSave() async {
    bool isMealNameValid = _validateMealName();
    bool areIngredientsValid = _validateIngredientInputs();
    if (!isMealNameValid || !areIngredientsValid) {
      return;
    }

    await ShoppingListDao.update(this._shoppingList!.id,
        _shoppingListNameController.value.text.trim());
    _listItems.forEach((item) async {
      String name = item.nameController.value.text.trim();
      String quantity = item.quantityController.value.text.trim();
      if (item.isNew) {
        await ShoppingItemDao.save(this._shoppingList!.id, name, quantity);
      } else {
        ShoppingItem shoppingItem = item.item;
        await ShoppingItemDao.update(shoppingItem.id, name, quantity);
      }
    });
    _listItemsToRemove.forEach((id) async => await ShoppingItemDao.deleteById(id));

    _exitEditMode();
    _reloadForm(this.widget.arg?.shoppingListId);

  }

  bool _validateMealName() {
    if (_shoppingListNameController.value.text.trim().isEmpty) {
      setState(() => _isShoppingListNameError = true);
      return false;
    }
    setState(() => _isShoppingListNameError = false);
    return true;
  }

  bool _validateIngredientInputs() {
    Iterable<ShoppingListItemController> emptyItems = _listItems
        .where((item) => item.nameController.value.text.trim().isEmpty);
    if (emptyItems.length == 0) {
      return true;
    }

    _resetListItemNameErrors();
    emptyItems
        .forEach((item) {
      item.isNameError = true;
    });
    setState(() => _listItems = _listItems);

    return false;
  }

  void _resetListItemNameErrors() {
    _listItems.forEach((item) {
      item.isNameError = false;
    });
  }

  void _resetShoppingListName() {
    _shoppingListNameController.value = TextEditingValue(text: _shoppingList!.name);
  }

  void _reloadForm(int? shoppingListId) {
    if (shoppingListId != null) {
      _loadMeal(shoppingListId);
      _loadListItems(shoppingListId);
    }
  }

  void _addEmptyListItem() {
    setState(() {
      _listItems.add(ShoppingListItemController(
        ShoppingItem(
            id: DateTime.now().microsecondsSinceEpoch,
            name: "",
            quantity: "",
            bought: false,
        ),
        true,
        false,
        true,
      ));
    });
  }

  void _removeListItem(int id) {
    ShoppingListItemController idToRemove =
    _listItems.firstWhere((item) => item.item.id == id);
    setState(() {
      _listItems.removeWhere((item) => item.item.id == id);
      _listItemsToRemove.add(idToRemove.item.id);
    });
  }
}
