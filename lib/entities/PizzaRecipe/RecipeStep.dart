import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';

class RecipeStep {
  final String name;
  final String waitDescription;
  final String waitUnit;
  final int waitMin;
  final int waitMax;
  final String description;
  final List<RecipeSubStep> subSteps;

  RecipeStep(this.name, this.waitDescription, this.description, this.waitUnit, this.waitMin, this.waitMax, this.subSteps);
}