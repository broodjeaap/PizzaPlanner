import 'package:flutter/material.dart';
import 'package:pizzaplanner/util.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';

import 'package:pizzaplanner/entities/PizzaRecipe/Ingredients.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/util.dart';
import 'package:yaml/yaml.dart';

class PizzaRecipe {
  final String name;
  final String description;
  final Ingredients ingredients;

  final List<RecipeStep> recipeSteps;

  PizzaRecipe(this.name, this.description, this.ingredients, this.recipeSteps);

  Widget getIngredientsTable(int pizzaCount, int doughBallSize){
    return ingredients.getIngredientsTable(pizzaCount, doughBallSize);
  }

  static Future<PizzaRecipe> fromYaml(yamlPath) async{
    String yamlString = await loadAsset(yamlPath);
    var yaml = loadYaml(yamlString);
    var recipe = yaml["recipe"];

    String name = recipe["name"];
    String description = recipe["description"];

    YamlMap ingredientsBlock = recipe["ingredients"];
    String ingredientMethod = ingredientsBlock["method"];
    YamlList ingredients = ingredientsBlock["items"];

    var newIngredients = Map<String, Ingredient>.fromIterable(ingredients,
      key: (ingredient) => ingredient["name"],
      value: (ingredient) => Ingredient(ingredient["name"], ingredient["unit"], ingredient["value"])
    );

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
      Ingredients(newIngredients, ingredientMethod),
      newRecipeSteps
    );
  }

  Duration getMinDuration(){
    return Duration(seconds: recipeSteps.map((recipeStep) => recipeStep.getWaitMinInSeconds()).reduce((a, b) => a+b));
  }

  Duration getCurrentDuration(){
    return Duration(seconds: recipeSteps.map((recipeStep) => recipeStep.getCurrentWaitInSeconds()).reduce((a, b) => a+b));
  }

  String toString() {
    return "PizzaRecipe(${this.name}, ${this.ingredients.ingredients.length}, ${this.recipeSteps.length})";
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

