import 'package:flutter/material.dart';

import 'package:pizzaplanner/util.dart';

class Ingredient {
  final String name;
  final String unit;
  final double value;

  Ingredient(this.name, this.unit, this.value);

  Widget getIngredientWidget(int weight){
    return Row(
      children: <Widget>[
        Text("${this.name.capitalize()}: "),
        Text("${this.getAbsolute(weight)}$unit")
      ],
    );
  }

  int getAbsolute(int weight) {
    return (this.value * weight).toInt();
  }
}