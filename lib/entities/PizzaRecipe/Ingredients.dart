import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';

class Ingredients {
  final Map<String, Ingredient> ingredients;
  final String method;

  Ingredients(this.ingredients, this.method);
}