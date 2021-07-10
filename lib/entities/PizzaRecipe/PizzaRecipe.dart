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

  static Future<PizzaRecipe> fromYaml() async{
    String yamlString = await loadAsset("assets/recipes/neapolitan_cold.yaml");
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

      YamlMap waitMap = step.containsKey("wait") ? step["wait"] : YamlList();
      String waitUnit = waitMap["unit"];
      int waitMin = waitMap["min"];
      int waitMax = waitMap["max"];
      print(step);

      YamlList subSteps = step.containsKey("substeps") ? step["substeps"] : YamlList();
      var newSubSteps = List.generate(subSteps.length, (j) {
        var subStep = subSteps[j];
        return RecipeSubStep(subStep["name"], subStep["description"]);
      });
      return RecipeStep(
        stepName,
        stepDescription,
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
}

