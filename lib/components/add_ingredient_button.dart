import 'package:flutter/material.dart';

class AddIngredientButton extends StatelessWidget {
  final VoidCallback _addEmptyIngredient;

  AddIngredientButton(this._addEmptyIngredient);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50.0,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          child: IconButton(
            onPressed: this._addEmptyIngredient,
            icon: Icon(
              Icons.plus_one,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

}
