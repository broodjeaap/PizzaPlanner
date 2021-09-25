import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/util.dart';

import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:yaml/yaml.dart';

part 'pizza_recipe.g.dart';

@HiveType(typeId: 0)
class PizzaRecipe extends HiveObject {
  static const String hiveName = "PizzaRecipes";
  
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
  
  @HiveField(5)
  String? imgUrl;

  PizzaRecipe(this.name, this.description, this.ingredients, this.recipeSteps, {String? image}){
    imgUrl = image;
  }
  
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

  static Future<PizzaRecipe> fromYamlAsset(String yamlPath) async{
    final String yamlString = await loadAsset(yamlPath);
    return fromYaml(yamlString);
  }

  static Future<PizzaRecipe> fromYaml(String yamlString) async{
    final yaml = loadYaml(yamlString);
    final YamlMap recipe = yaml["recipe"] as YamlMap;

    final String name = recipe["name"] as String;
    final String? image = recipe.containsKey("image") ? recipe["image"] as String : null;
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
      newRecipeSteps,
      image: image
    );
  }
  
  String toYaml(){
    final yaml = StringBuffer("recipe:\n");
    
    // Name
    yaml.writeln(indent(1, 'name: "$name"'));
    
    // image url
    if (imgUrl != null){
      yaml.writeln(indent(1, 'image: "$imgUrl"'));
    }
    
    // Description
    yaml.writeln(indent(1, 'description: >'));
    for (final line in description.split("\n")){
      yaml.writeln(indent(2, line));
    }
    
    // Ingredients
    yaml.writeln(indent(1, 'ingredients:'));
    for (final ingredient in ingredients){
      yaml.writeln(indent(2, "- name: ${ingredient.name}"));
      yaml.writeln(indent(3, "unit: ${ingredient.unit}"));
      yaml.writeln(indent(3, "value: ${ingredient.value}"));
    }
    
    // Steps
    if (recipeSteps.isNotEmpty){
      yaml.writeln(indent(1, "steps:"));
    }
    for (final recipeStep in recipeSteps) {
      yaml.writeln(indent(2, "- name: ${recipeStep.name}"));
      
      // Wait
      if (recipeStep.waitUnit != "none"){
        yaml.writeln(indent(3, "wait:"));
        yaml.writeln(indent(4, "description: >"));
        for (final line in recipeStep.waitDescription.split("\n")) {
          yaml.writeln(indent(5, line));
        }
        yaml.writeln(indent(4, "unit: ${recipeStep.waitUnit}"));
        yaml.writeln(indent(4, "min: ${recipeStep.waitMin}"));
        yaml.writeln(indent(4, "max: ${recipeStep.waitMax}"));
      }
      
      // description
      yaml.writeln(indent(3, "description: >"));
      for (final line in recipeStep.description.split("\n")) {
        yaml.writeln(indent(4, line));
      }

      // Steps
      if (recipeStep.subSteps.isNotEmpty){
        yaml.writeln(indent(3, "substeps:"));
      }
      for (final subStep in recipeStep.subSteps){
        yaml.writeln(indent(4, "- name: ${subStep.name}"));
        yaml.writeln(indent(5, "description: >"));
        for (final line in subStep.description.split("\n")) {
          yaml.writeln(indent(6, line));
        }
      }
    }
    return yaml.toString();
  }
  
  String indent(int indent, String s){
    return "${' '*indent*2}$s";
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

