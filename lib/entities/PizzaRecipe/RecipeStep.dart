import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/pages/PizzaEventPage.dart';

part 'RecipeStep.g.dart';

@HiveType(typeId: 2)
class RecipeStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String waitDescription;

  @HiveField(2)
  String waitUnit;

  @HiveField(3)
  int waitMin;

  @HiveField(4)
  int waitMax;

  @HiveField(5)
  int? waitValue;

  @HiveField(6)
  String description;

  @HiveField(7)
  List<RecipeSubStep> subSteps;

  @HiveField(8)
  DateTime? completedOn;

  bool get completed => _completed();

  RecipeStep(this.name, this.description, this.waitDescription, this.waitUnit, this.waitMin, this.waitMax, this.subSteps) {
    waitValue = waitMin;
  }

  bool _completed(){
    return subSteps.length > 0 ?
        subSteps.every((subStep) => subStep.completed) :
        completedOn != null;
  }

  Widget buildPizzaEventRecipeStepWidget(BuildContext context, PizzaEventPageState pizzaEventPage){
    return this.subSteps.length > 0 ?
        buildPizzaEventRecipeStepWidgetWithSubSteps(context, pizzaEventPage) :
        buildPizzaEventRecipeStepWidgetWithoutSubSteps(context, pizzaEventPage);
  }

  Widget buildPizzaEventRecipeStepWidgetWithSubSteps(BuildContext context, PizzaEventPageState pizzaEventPage) {
    int recipeSubStepsCompleted = this.subSteps.where((subStep) => subStep.completed).length;
    int recipeSubSteps = this.subSteps.length;
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(FontAwesome5.sitemap),
          Text(this.name),
          Text("$recipeSubStepsCompleted/$recipeSubSteps")
        ],
      ),
      children: <Widget>[
        Text(this.description),

      ] + subSteps.map((subStep) => subStep.buildTest(context, pizzaEventPage)).toList() //subStep.buildPizzaEventSubStepWidget(context, pizzaEventPage)).toList()
    );
  }

  Widget buildPizzaEventRecipeStepWidgetWithoutSubSteps(BuildContext context, PizzaEventPageState pizzaEventPage) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(FontAwesome5.sitemap),
          Text(this.name),
          Text("${this.completedOn == null ? 0 : 1}/1")
        ],
      ),
      children: <Widget>[
        Text(this.description),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(this.name),
            Checkbox(
              value: this.completedOn != null,
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
        )
      ]
    );
  }

  int convertToSeconds(int value){
    switch (waitUnit){
      case "minutes": {
        return value * 60;
      }
      case "hours": {
        return value * 60 * 60;
      }
      case "days": {
        return value * 60 * 60 * 24;
      }
      default: {
        return value;
      }
    }
  }

  int getWaitMinInSeconds(){
    return convertToSeconds(this.waitMin);
  }

  int getWaitMaxInSeconds() {
    return convertToSeconds(this.waitMax);
  }

  int getCurrentWaitInSeconds() {
    return convertToSeconds(this.waitValue!);
  }
}