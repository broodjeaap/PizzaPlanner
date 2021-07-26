import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:pizzaplanner/util.dart';

part 'Ingredient.g.dart';

@HiveType(typeId: 1)
class Ingredient extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String unit;

  @HiveField(2)
  double value;

  Ingredient(this.name, this.unit, this.value);

  TableRow getIngredientTableRow(int pizzaCount, int doughBallSize){
    return TableRow(
      children: <Widget>[
        TableCell(child: Center(child: Text("${this.name.capitalize()}"))),
        TableCell(child: Center(child: Text("${this.getAbsolute(doughBallSize)}$unit"))),
        TableCell(child: Center(child: Text("${this.getAbsolute(pizzaCount * doughBallSize)}$unit"))),
      ],
    );
  }

  int getAbsolute(int weight) {
    return (this.value * weight).toInt();
  }
}