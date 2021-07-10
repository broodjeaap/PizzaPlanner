import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';

class Ingredients {
  final Map<String, Ingredient> ingredients;
  final String method;

  Ingredients(this.ingredients, this.method);

  Widget getIngredientsWidget(int weight) {
    return Container(
      child: Column(
        children: ingredients.values.map((ingredient) => ingredient.getIngredientWidget(weight)).toList()
      )
    );
  }
}