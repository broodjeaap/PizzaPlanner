import 'package:flutter/services.dart' show rootBundle;
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';

import 'package:pizzaplanner/entities/PizzaRecipe/Ingredients.dart';
import 'package:yaml/yaml.dart';

class PizzaRecipe {
  final String name;
  final String description;
  final Ingredients ingredients;

  PizzaRecipe(this.name, this.description, this.ingredients);

  static Future<PizzaRecipe> fromYaml() async{
    String yamlString = await loadAsset("assets/recipes/neapolitan.yaml");
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

    print(newIngredients);

    return PizzaRecipe(
      name,
      description,
      Ingredients(newIngredients, ingredientMethod)
    );
  }
}

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}