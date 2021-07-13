import 'package:flutter/material.dart';

import 'package:floor/floor.dart';

import 'package:pizzaplanner/util.dart';

@entity
class Ingredient {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String unit;
  final double value;

  Ingredient(this.name, this.unit, this.value, {this.id});

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