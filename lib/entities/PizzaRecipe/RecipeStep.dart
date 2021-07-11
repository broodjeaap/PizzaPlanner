import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';

class RecipeStep {
  final String name;
  final String waitDescription;
  final String waitUnit;
  final int waitMin;
  final int waitMax;
  late int waitValue;
  final String description;
  final List<RecipeSubStep> subSteps;

  RecipeStep(this.name, this.description, this.waitDescription, this.waitUnit, this.waitMin, this.waitMax, this.subSteps) {
    waitValue = waitMin;
  }
}