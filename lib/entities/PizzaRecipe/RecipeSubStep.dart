import 'package:floor/floor.dart';

@entity
class RecipeSubStep {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final String description;

  RecipeSubStep(this.name, this.description, {this.id});
}