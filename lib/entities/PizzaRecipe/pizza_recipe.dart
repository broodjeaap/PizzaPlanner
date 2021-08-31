import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/pages/pizza_event_page.dart';
import 'package:pizzaplanner/util.dart';

import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:yaml/yaml.dart';

part 'pizza_recipe.g.dart';

@HiveType(typeId: 0)
class PizzaRecipe extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  List<Ingredient> ingredients;

  @HiveField(3)
  List<RecipeStep> recipeSteps;

  PizzaRecipe(this.name, this.description, this.ingredients, this.recipeSteps);
  
  String getShortDescriptionString(){
    if (this.description.length < 150) { // TODO 150?
      return this.description;
    }
    var endOfLineIndex = this.description.indexOf(RegExp("[.]|\$")) + 1;
    if (endOfLineIndex >= 150){
      var first150 = this.description.substring(0, 150);
      return "$first150...";
    }
    return this.description.substring(0, endOfLineIndex);
  }
  Table getIngredientsTable(int pizzaCount, int doughBallSize) {
    return Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(2),
        },
        children: <TableRow>[
          TableRow(
              children: <TableCell>[
                TableCell(child: Center(child: Text("Ingredient"))),
                TableCell(child: Center(child: Text("Per Ball"))),
                TableCell(child: Center(child: Text("Total"))),
              ]
          )

        ] +
            ingredients.map((ingredient) =>
                ingredient.getIngredientTableRow(pizzaCount, doughBallSize))
                .toList()
    );
  }

  int getStepsCompleted(){
    var stepCount = 0;
    for (var recipeStep in this.recipeSteps) {
      if (!recipeStep.completed) {
        return stepCount;
      }
      stepCount++;
    }
    return stepCount;
  }

  static Future<PizzaRecipe> fromYaml(String yamlPath) async{
    String yamlString = await loadAsset(yamlPath);
    var yaml = loadYaml(yamlString);
    YamlMap recipe = yaml["recipe"] as YamlMap;

    String name = recipe["name"] as String;
    String description = recipe["description"] as String;

    YamlList ingredients = recipe["ingredients"] as YamlList;

    List<Ingredient> newIngredients = ingredients.map(
            (ingredient) => Ingredient(
                ingredient["name"] as String, 
                ingredient["unit"] as String, 
                ingredient["value"] as double
            )).toList();

    YamlList steps = recipe["steps"] as YamlList;
    var newRecipeSteps = List.generate(steps.length, (i) {
      YamlMap step = steps[i] as YamlMap;
      String stepName = step["name"] as String;
      String stepDescription = step["description"] as String;

      String waitUnit = "none";
      String waitDescription = "";
      int waitMin = 0;
      int waitMax = 0;

      if (step.containsKey("wait")) {
        YamlMap waitMap = step["wait"] as YamlMap;

        waitDescription = waitMap["description"] as String;
        waitUnit = waitMap["unit"] as String;
        waitMin = waitMap["min"] as int;
        waitMax = waitMap["max"] as int;
      }

      YamlList subSteps = step.containsKey("substeps") ? step["substeps"] as YamlList : YamlList();
      var newSubSteps = List.generate(subSteps.length, (j) {
        var subStep = subSteps[j];
        return RecipeSubStep(
            subStep["name"] as String, 
            subStep["description"] as String
        );
      });
      return RecipeStep(
        stepName,
        stepDescription,
        waitDescription,
        waitUnit,
        waitMin,
        waitMax,
        newSubSteps
      );
    });

    return PizzaRecipe(
      name,
      description,
      newIngredients,
      newRecipeSteps
    );
  }

  Duration getMinDuration(){
    return Duration(seconds: recipeSteps.map((recipeStep) => recipeStep.getWaitMinInSeconds()).reduce((a, b) => a+b));
  }

  Duration getMaxDuration(){
    return Duration(seconds: recipeSteps.map((recipeStep) => recipeStep.getWaitMaxInSeconds()).reduce((a, b) => a+b));
  }

  Duration getCurrentDuration(){
    return Duration(seconds: recipeSteps.map((recipeStep) => recipeStep.getCurrentWaitInSeconds()).reduce((a, b) => a+b));
  }

  String toString() {
    return "PizzaRecipe(${this.name}, ${this.ingredients.length}, ${this.recipeSteps.length})";
  }

  Table getStepTimeTable(DateTime startTime) {
    List<TableRow> stepRows = [];
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch);
    for (var recipeStep in this.recipeSteps.reversed) {
      Duration stepWaitDuration = Duration(seconds: recipeStep.getCurrentWaitInSeconds());
      stepRows.add(
        TableRow(
          children: <TableCell>[
            TableCell(child: Center(child: Text(recipeStep.name))),
            TableCell(child: Center(child: Text(getDateFormat().format(dateTime.subtract(stepWaitDuration)))))
          ]
        )
      );
      dateTime = dateTime.subtract(stepWaitDuration);
    }
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: <TableRow>[
        TableRow(
          children: <TableCell>[
            TableCell(child: Center(child: Text("Step"))),
            TableCell(child: Center(child: Text("When"))),
          ]
        )
      ] + stepRows.reversed.toList()
    );
  }
}

