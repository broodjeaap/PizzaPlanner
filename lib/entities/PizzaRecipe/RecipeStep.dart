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

  int convertToSeconds(int value){
    switch (waitUnit){
      case "minutes": {
        return value * 60;
      }
      case "hours": {
        return value * 60 * 60;
      }
      case "days": {
        return value * 60 * 60 * 24;
      }
      default: {
        return value;
      }
    }
  }

  int getWaitMinInSeconds(){
    return convertToSeconds(this.waitMin);
  }

  int getWaitMaxInSeconds() {
    return convertToSeconds(this.waitMax);
  }

  int getCurrentWaitInSeconds() {
    return convertToSeconds(this.waitValue);
  }
}