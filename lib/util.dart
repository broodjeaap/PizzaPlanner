import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pizzaplanner/entities/PizzaDatabase.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

Future<List<PizzaRecipe>> loadYamlRecipesIntoDb() async {
  // load recipes from yaml files in the asset directory
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  final List<String> fileList = manifestMap.keys.toList();
  final List<PizzaRecipe> newPizzaRecipes = [];
  for (var filePath in fileList) {
    if (filePath.startsWith("assets/recipes") && filePath.endsWith(".yaml")) {
      var parsedPizzaRecipe = await PizzaRecipe.fromYaml(filePath);
      await parsedPizzaRecipe.item1.insert();
      newPizzaRecipes.add(parsedPizzaRecipe.item1);
      print(parsedPizzaRecipe.item1.name);
      parsedPizzaRecipe.item2.forEach((ingredient) async { await ingredient.insert(); });
      parsedPizzaRecipe.item3.forEach((recipeStep) async { await recipeStep.insert(); });
      parsedPizzaRecipe.item4.forEach((recipeSubStep) async { await recipeSubStep.insert(); });
      print(parsedPizzaRecipe.item1.description);
    }
  }
  return newPizzaRecipes;
}

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

extension StringExtensions on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}

DateFormat getDateFormat(){
  return DateFormat("yyyy-MM-dd H:mm");
}

Future<PizzaDatabase> getDatabase() async {
  return await $FloorPizzaDatabase.databaseBuilder("pizza.db").build();
}