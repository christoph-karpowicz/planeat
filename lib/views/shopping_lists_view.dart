import 'package:flutter/material.dart';
import 'package:planeat/components/nav.dart';
import 'package:planeat/components/nav_icons.dart';
import 'package:planeat/components/shopping_list_list_item.dart';
import 'package:planeat/db/shopping_list_dao.dart';
import 'package:planeat/main.dart';
import 'package:planeat/model/shopping_list.dart';

class ShoppingListsView extends StatefulWidget {
  static const routeName = '/shopping_lists';

  @override
  _ShoppingListsViewState createState() => _ShoppingListsViewState();

}

class _ShoppingListsViewState extends State<ShoppingListsView> {
  final ValueNotifier<List<ShoppingList>> _shoppingLists = ValueNotifier(<ShoppingList>[]);

  @override
  void initState() {
    super.initState();
    _loadShoppingLists();
  }

  void _loadShoppingLists() async {
    _shoppingLists.value = await ShoppingListDao.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping lists'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, CalendarView.routeName),
        ),
      ),
      body: Column(
          children: [
            Expanded(
              // Within the `FirstScreen` widget
              child: ValueListenableBuilder<List<ShoppingList>>(
                  valueListenable: _shoppingLists,
                  builder: (context, items, _) {
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ShoppingListListItem(
                            _loadShoppingLists,
                            items[index],
                            key: Key(items[index].id.toString()));
                      },
                      shrinkWrap: true,
                    );
                  }
              ),
            ),
            Nav(NavIcon.shopping_lists),
          ]
      ),
    );
  }
}
