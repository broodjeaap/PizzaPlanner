import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:pizzaplanner/util.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 1)
class Ingredient extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String unit;

  @HiveField(2)
  double value;
  
  @HiveField(3)
  bool bought = false;

  Ingredient(this.name, this.unit, this.value);

  TableRow getIngredientTableRow(int pizzaCount, int doughBallSize){
    return TableRow(
      children: <Widget>[
        TableCell(child: Center(child: Text(name.capitalize()))),
        TableCell(child: Center(child: Text("${getAbsoluteString(doughBallSize)}$unit"))),
        TableCell(child: Center(child: Text("${getAbsoluteString(pizzaCount * doughBallSize)}$unit"))),
      ],
    );
  }

  double getAbsolute(int weight) {
    return (this.value * weight);
  }

  String getAbsoluteString(int weight){
    double ingredientWeight = this.getAbsolute(weight);
    if (this.value < 0.05){
      return ingredientWeight.toStringAsFixed(2);
    }
    return ingredientWeight.toStringAsFixed(0);
  }
}