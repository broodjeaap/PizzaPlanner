
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

class PizzaEvent {
  final String name;
  final PizzaRecipe recipe;
  final int pizzaCount;
  final int doughBallSize;
  final DateTime dateTime;

  PizzaEvent(
    this.name,
    this.recipe,
    this.pizzaCount,
    this.doughBallSize,
    this.dateTime
  );
}