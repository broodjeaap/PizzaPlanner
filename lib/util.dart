import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';

Future<List<PizzaRecipe>> getRecipes() async {
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