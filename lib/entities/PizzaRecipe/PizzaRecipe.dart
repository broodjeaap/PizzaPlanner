import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/pages/PizzaEventPage.dart';
import 'package:pizzaplanner/util.dart';

import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:yaml/yaml.dart';

part 'PizzaRecipe.g.dart';

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

  static Future<PizzaRecipe> fromYaml(yamlPath) async{
    String yamlString = await loadAsset(yamlPath);
    var yaml = loadYaml(yamlString);
    var recipe = yaml["recipe"];

    String name = recipe["name"];
    String description = recipe["description"];

    YamlList ingredients = recipe["ingredients"];

    List<Ingredient> newIngredients = ingredients.map((ingredient) => Ingredient(ingredient["name"], ingredient["unit"], ingredient["value"])).toList();

    YamlList steps = recipe["steps"];
    var newRecipeSteps = List.generate(steps.length, (i) {
      YamlMap step = steps[i];
      String stepName = step["name"];
      String stepDescription = step["description"];

      String waitUnit = "none";
      String waitDescription = "";
      int waitMin = 0;
      int waitMax = 0;

      if (step.containsKey("wait")) {
        YamlMap waitMap = step["wait"];

        waitDescription = waitMap["description"];
        waitUnit = waitMap["unit"];
        waitMin = waitMap["min"];
        waitMax = waitMap["max"];
      }

      YamlList subSteps = step.containsKey("substeps") ? step["substeps"] : YamlList();
      var newSubSteps = List.generate(subSteps.length, (j) {
        var subStep = subSteps[j];
        return RecipeSubStep(subStep["name"], subStep["description"]);
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

