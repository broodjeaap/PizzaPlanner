import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

Future<List<PizzaRecipe>> getRecipes() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  final List<String> fileList = manifestMap.keys.toList();
  final List<PizzaRecipe> pizzaRecipes = [];
  for (var filePath in fileList) {
    if (filePath.startsWith("assets/recipes") && filePath.endsWith(".yaml")) {
      PizzaRecipe pizzaRecipe = await PizzaRecipe.fromYaml(filePath);
      pizzaRecipes.add(pizzaRecipe);
    }
  }
  return pizzaRecipes;
}

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

extension StringExtensions on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}