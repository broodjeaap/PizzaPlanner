import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/pages/PizzaEventPage.dart';

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

  @HiveField(8)
  DateTime? completedOn;
  bool get completed => _completed();

  @HiveField(9)
  int notificationId = -1;

  RecipeStep(this.name, this.description, this.waitDescription, this.waitUnit, this.waitMin, this.waitMax, this.subSteps) {
    waitValue = waitMin;
  }

  bool _completed(){
    return subSteps.length > 0 ?
        subSteps.every((subStep) => subStep.completed) :
        completedOn != null;
  }

  void completeStepNow(){
    if (subSteps.isNotEmpty){
      subSteps.forEach((subStep) { subStep.completeNow(); });
    } else {
      completedOn = DateTime.now();
    }
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