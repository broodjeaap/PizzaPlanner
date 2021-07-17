
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

import 'package:floor/floor.dart';

@Entity(
  tableName: "PizzaEvent",
  foreignKeys: [
    ForeignKey(childColumns: ["recipeId"], parentColumns: ["id"], entity: PizzaRecipe)
  ]
)
class PizzaEvent {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final String name;
  final int recipeId; // foreign key to recipe for this event
  final int pizzaCount;
  final int doughBallSize;
  final DateTime dateTime;

  PizzaEvent(
    this.recipeId,
    this.name,
    this.pizzaCount,
    this.doughBallSize,
    this.dateTime,
    {this.id,}
  );
}