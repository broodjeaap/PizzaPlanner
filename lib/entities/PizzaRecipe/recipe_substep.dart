
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/pages/pizza_event_page.dart';

part 'recipe_substep.g.dart';

@HiveType(typeId: 3)
class RecipeSubStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime? completedOn;

  bool get completed => completedOn != null;

  void completeNow(){
    completedOn = DateTime.now();
  }

  RecipeSubStep(this.name, this.description);
}