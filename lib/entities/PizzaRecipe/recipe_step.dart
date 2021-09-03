import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/pages/pizza_event_page.dart';

part 'recipe_step.g.dart';

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

  @HiveField(8) 
  late DateTime dateTime;
  
  @HiveField(9)
  late bool _completed;
  
  bool get completed => _checkCompleted();

  @HiveField(10)
  int notificationId = -1;

  RecipeStep(this.name, this.description, this.waitDescription, this.waitUnit, this.waitMin, this.waitMax, this.subSteps, {DateTime? dateTime, bool completed=false}) {
    waitValue = waitMin;
    this.dateTime = dateTime ?? DateTime.now();
    _completed = completed;
  }

  bool _checkCompleted(){
    return subSteps.isNotEmpty ?
        subSteps.every((subStep) => subStep.completed) :
        _completed;
  }
  
  void completeStepNow() {
    for (final subStep in subSteps){
      subStep.completeNow();
    }
    _completed = true;
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
    return convertToSeconds(waitMin);
  }

  int getWaitMaxInSeconds() {
    return convertToSeconds(waitMax);
  }

  int getCurrentWaitInSeconds() {
    return convertToSeconds(waitValue!);
  }
}