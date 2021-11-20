import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:yaml/yaml.dart';

Future<List<PizzaRecipe>> getLocalRecipes() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent) as Map<String, dynamic>;
  final List<String> fileList = manifestMap.keys.toList();
  final List<PizzaRecipe> pizzaRecipes = [];
  for (final filePath in fileList) {
    if (filePath.startsWith("assets/recipes") && filePath.endsWith(".yaml")) {
      final PizzaRecipe pizzaRecipe = await PizzaRecipe.fromYamlAsset(filePath);
      pizzaRecipes.add(pizzaRecipe);
    }
  }
  return pizzaRecipes;
}

Future<List<PizzaRecipe>> getRecipesFromGithub() async {
  const String initialRecipeListUrl = "https://raw.githubusercontent.com/broodjeaap/PizzaRecipes/master/app_init/recipes.yaml";

  final uri = Uri.parse(initialRecipeListUrl);
  if (!uri.isAbsolute){
    return const [];
  }
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      return const [];
    }

    final yamlBody = response.body;
    if (!yamlBody.startsWith("recipes:")){
      return const [];
    }
    final rootYaml = loadYaml(yamlBody) as YamlMap;
    final recipeList = rootYaml["recipes"] as YamlList;
    final returnRecipeList = <PizzaRecipe>[];
    for (final recipe in recipeList){
        returnRecipeList.add(await PizzaRecipe.fromParsedYaml(recipe as YamlMap));
    }
    return returnRecipeList;
  return const [];
}

Future<String> loadAsset(String path) async {
  return rootBundle.loadString(path);
}

extension StringExtensions on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}

DateFormat getDateFormat(){
  return DateFormat("yyyy-MM-dd H:mm");
}

String getTimeRemainingString(DateTime other, {DateTime? now}){
  now ??= DateTime.now();
  final duration = other.difference(now);
  final absDuration = duration.abs();
  String durationString = "";
  if (absDuration.inHours <= 0 && absDuration.inMinutes > 0) {
    durationString = "${"${absDuration.inMinutes} minute"}${absDuration.inMinutes > 1 ? "s" : ""}";
  }
  else if (absDuration.inDays <= 0 && absDuration.inHours > 0) {
    durationString = "${absDuration.inHours} hours";
  }
  else if (absDuration.inDays <= 31) {
    durationString = "${"${absDuration.inDays} day"}${absDuration.inDays > 1 ? "s" : ""}";
  }
  else {
    durationString = "${"${(absDuration.inDays / 7).floor()} week"}${absDuration.inDays >= 14 ? "s" : ""}";
  }
  return duration.isNegative ? "$durationString ago" : "In $durationString";
}