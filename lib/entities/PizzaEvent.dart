
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

part 'PizzaEvent.g.dart';

@HiveType(typeId: 4)
class PizzaEvent {
  @HiveField(0)
  String name;

  @HiveField(1)
  PizzaRecipe recipe;

  @HiveField(2)
  int pizzaCount;

  @HiveField(3)
  int doughBallSize;

  @HiveField(4)
  DateTime dateTime;

  PizzaEvent(
    this.name,
    this.recipe,
    this.pizzaCount,
    this.doughBallSize,
    this.dateTime
  );
}