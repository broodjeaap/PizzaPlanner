
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

import 'package:floor/floor.dart';

@entity
class PizzaEvent {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final String name;
  @ignore
  final PizzaRecipe recipe;
  final int pizzaCount;
  final int doughBallSize;
  final DateTime dateTime;

  PizzaEvent(
    this.name,
    this.recipe,
    this.pizzaCount,
    this.doughBallSize,
    this.dateTime,
    {this.id,}
  );
}