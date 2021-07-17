import 'package:flutter/material.dart';

import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

import 'package:pizzaplanner/util.dart';

@Entity(
  tableName: "Ingredient",
  foreignKeys: [
    ForeignKey(childColumns: ["pizzaRecipeId"], parentColumns: ["id"], entity: PizzaRecipe)
  ]
)
class Ingredient {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int pizzaRecipeId;

  final String name;
  final String unit;
  final double value;

  Ingredient(this.pizzaRecipeId, this.name, this.unit, this.value, {this.id});

  Future<void> insert() async {
    final database = await getDatabase();
    final ingredientDao = database.ingredientDao;
    await ingredientDao.insertIngredient(this);
  }

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