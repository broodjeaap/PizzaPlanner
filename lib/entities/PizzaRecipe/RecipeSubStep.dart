
import 'package:hive/hive.dart';

part 'RecipeSubStep.g.dart';

@HiveType(typeId: 3)
class RecipeSubStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime? completedOn;

  bool get completed => completedOn != null;

  RecipeSubStep(this.name, this.description);
}