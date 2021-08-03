
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/pages/PizzaEventPage.dart';

part 'RecipeSubStep.g.dart';

@HiveType(typeId: 3)
class RecipeSubStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime? completedOn;

  bool get completed => completedOn != null;

  RecipeSubStep(this.name, this.description);

  Widget buildPizzaEventSubStepWidget(PizzaEventPageState pizzaEventPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(this.name),
        Checkbox(
          value: this.completed,
          onChanged: (bool? newValue) async {
            if (newValue == null){
              return;
            }
            if (newValue){
              this.completedOn = DateTime.now();
            } else {
              this.completedOn = null;
            }
            await pizzaEventPage.widget.pizzaEvent.save();
            pizzaEventPage.triggerSetState();
          },
        )
      ],
    );
  }
}