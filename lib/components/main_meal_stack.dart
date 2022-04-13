import 'package:flutter/material.dart';
import 'package:planeat/dto/meal_item_dto.dart';
import 'package:intl/intl.dart';

class MainMealStack extends StatefulWidget {
  final MealItemDto _item;

  MainMealStack(this._item);

  @override
  _MainMealStackState createState() => _MainMealStackState();

}

class _MainMealStackState extends State<MainMealStack> {

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

                      },
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
            height: 60.0,
          ),

          Positioned(
            // left: 10,
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
