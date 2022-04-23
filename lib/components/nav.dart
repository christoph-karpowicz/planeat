import 'package:flutter/material.dart';
import 'package:planeat/components/nav_icons.dart';

class Nav extends StatelessWidget {
  late NavIcon active;

  Nav(NavIcon active, {Key? key}) : super(key: key) {
    this.active = active;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              height: 60,
              child: Row(
                children: [
                  Expanded(child: InkWell(
                    child: Icon(
                      Icons.calendar_month,
                      color: getColor(NavIcon.calendar),
                      size: 50.0,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/calendar'),
                  )),
                  Expanded(child: InkWell(
                    child: Icon(
                      Icons.restaurant,
                      color: getColor(NavIcon.meals),
                      size: 50.0,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/meals'),
                  )),
                  Expanded(child: InkWell(
                    child: Icon(
                      Icons.playlist_add_check,
                      color: getColor(NavIcon.shopping_lists),
                      size: 50.0,
                    ),
                    onTap: () => Navigator.pushNamed(context, '/shopping_lists'),
                  )),
                ],
              )
          ),
        ),
      ],
    );
  }

  Color getColor(NavIcon navIcon) {
    return this.active == navIcon ? Colors.black : Colors.black45;
  }
}
