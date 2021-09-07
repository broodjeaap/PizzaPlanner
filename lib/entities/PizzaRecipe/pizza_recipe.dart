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
  
  // Using this because deleting it from the box does weird things.
  // It seems to 'null' the item that you delete, and then reduce the size/length
  // cutting off the last item
  @HiveField(4)
  bool deleted = false;

  PizzaRecipe(this.name, this.description, this.ingredients, this.recipeSteps);
  
  String getShortDescriptionString(){
    if (description.length < 150) { // TODO 150?
      return description;
    }
    final endOfLineIndex = description.indexOf(RegExp("[.]|\$")) + 1;
    if (endOfLineIndex >= 150){
      final first150 = description.substring(0, 150);
      return "$first150...";
    }
    return description.substring(0, endOfLineIndex);
  }
  Table getIngredientsTable(int pizzaCount, int doughBallSize) {
    return Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(2),
        },
        children: <TableRow>[
          const TableRow(
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
    for (final recipeStep in recipeSteps) {
      if (!recipeStep.completed) {
        return stepCount;
      }
      stepCount++;
    }
    return stepCount;
  }

  static Future<PizzaRecipe> fromYaml(String yamlPath) async{
    final String yamlString = await loadAsset(yamlPath);
    final yaml = loadYaml(yamlString);
    final YamlMap recipe = yaml["recipe"] as YamlMap;

    final String name = recipe["name"] as String;
    final String description = recipe["description"] as String;

    final YamlList ingredients = recipe["ingredients"] as YamlList;

    final List<Ingredient> newIngredients = ingredients.map(
            (ingredient) => Ingredient(
                ingredient["name"] as String, 
                ingredient["unit"] as String, 
                ingredient["value"] as double
            )).toList();

    final YamlList steps = recipe["steps"] as YamlList;
    final newRecipeSteps = List.generate(steps.length, (i) {
      final YamlMap step = steps[i] as YamlMap;
      final String stepName = step["name"] as String;
      final String stepDescription = step["description"] as String;

      String waitUnit = "none";
      String waitDescription = "";
      int waitMin = 0;
      int waitMax = 0;

      if (step.containsKey("wait")) {
        final YamlMap waitMap = step["wait"] as YamlMap;

        waitDescription = waitMap["description"] as String;
        waitUnit = waitMap["unit"] as String;
        waitMin = waitMap["min"] as int;
        waitMax = waitMap["max"] as int;
      }

      final YamlList subSteps = step.containsKey("substeps") ? step["substeps"] as YamlList : YamlList();
      final newSubSteps = List.generate(subSteps.length, (j) {
        final subStep = subSteps[j];
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

  @override
  String toString() {
    return "PizzaRecipe($name, ${ingredients.length}, ${recipeSteps.length})";
  }

  Table getStepTimeTable(DateTime startTime) {
    final List<TableRow> stepRows = [];
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch);
    for (final recipeStep in recipeSteps.reversed) {
      final Duration stepWaitDuration = Duration(seconds: recipeStep.getCurrentWaitInSeconds());
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
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
      },
      children: <TableRow>[
        const TableRow(
          children: <TableCell>[
            TableCell(child: Center(child: Text("Step"))),
            TableCell(child: Center(child: Text("When"))),
          ]
        )
      ] + stepRows.reversed.toList()
    );
  }
}

