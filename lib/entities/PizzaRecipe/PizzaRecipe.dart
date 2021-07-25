import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:pizzaplanner/util.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';

import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:tuple/tuple.dart';
import 'package:yaml/yaml.dart';

@entity
class PizzaRecipe {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String description;

  @ignore
  List<Ingredient> ingredients = [];

  @ignore
  List<RecipeStep> recipeSteps = [];

  PizzaRecipe(this.name, this.description, {this.id});
  
  Future<void> insert() async {
    final database = await getDatabase();
    final pizzaRecipeDao = database.pizzaRecipeDao;
    await pizzaRecipeDao.insertPizzaRecipe(this);
  }

  Future<List<RecipeStep>> getRecipeSteps() async {
    final database = await getDatabase();
    final recipeStepDao = database.recipeStepDao;
    return await recipeStepDao.getPizzaRecipeSteps(this.id!);
  }

  Future<Table> getIngredientsTable(int pizzaCount, int doughBallSize) async {
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
            this.ingredients.map((ingredient) =>
                ingredient.getIngredientTableRow(pizzaCount, doughBallSize))
                .toList()
    );
  }

  static Future<Tuple4<PizzaRecipe, List<Ingredient>, List<RecipeStep>, List<RecipeSubStep>>> fromYaml(yamlPath) async{
    String yamlString = await loadAsset(yamlPath);
    var yaml = loadYaml(yamlString);
    var recipe = yaml["recipe"];

    String name = recipe["name"];
    String description = recipe["description"];

    PizzaRecipe pizzaRecipe = PizzaRecipe(name, description);
    pizzaRecipe.insert();

    YamlList ingredientsYamlList = recipe["ingredients"];
    List<Ingredient> ingredients = ingredientsYamlList.map((ingredientYaml) => Ingredient(pizzaRecipe.id!, ingredientYaml["name"], ingredientYaml["unit"], ingredientYaml["value"])).toList();


    YamlList steps = recipe["steps"];
    List<RecipeStep> recipeSteps = [];
    List<RecipeSubStep> recipeSubSteps = [];
    for (var step in steps){
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
      var recipeStep = RecipeStep(
          pizzaRecipe.id!,
          stepName,
          stepDescription,
          waitDescription,
          waitUnit,
          waitMin,
          waitMax
      );
      recipeSteps.add(
        recipeStep
      );

      YamlList subSteps = step.containsKey("substeps") ? step["substeps"] : YamlList();
      for (var subStep in subSteps ) {
        recipeSubSteps.add(
            RecipeSubStep(
                recipeStep.id!,
                subStep["name"],
                subStep["description"]
            )
        );
      }
    }
    return Tuple4(pizzaRecipe, ingredients, recipeSteps, recipeSubSteps);
  }

  Duration getMinDuration() {
    return Duration(seconds: recipeSteps.map((recipeStep) => recipeStep.getWaitMinInSeconds()).reduce((a, b) => a+b));
  }

  Duration getMaxDuration() {
    return Duration(seconds: recipeSteps.map((recipeStep) => recipeStep.getWaitMaxInSeconds()).reduce((a, b) => a+b));
  }

  Future<Duration> getCurrentDuration() async {
    return Duration(seconds: this.recipeSteps.map((recipeStep) => recipeStep.getCurrentWaitInSeconds()).reduce((a, b) => a+b));
  }

  String toString() {
    return "PizzaRecipe(${this.name})";
  }

  Future<Table> getStepTimeTable(DateTime startTime) async {
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

