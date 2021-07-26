import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';

part 'RecipeStep.g.dart';

@HiveType(typeId: 2)
class RecipeStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String waitDescription;

  @HiveField(2)
  String waitUnit;

  @HiveField(3)
  int waitMin;

  @HiveField(4)
  int waitMax;

  @HiveField(5)
  int? waitValue;

  @HiveField(6)
  String description;

  @HiveField(7)
  List<RecipeSubStep> subSteps;

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
    return convertToSeconds(this.waitValue!);
  }
}