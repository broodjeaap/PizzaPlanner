import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/util.dart';

@Entity(
  tableName: "RecipeStep",
  foreignKeys: [
    ForeignKey(childColumns: ["pizzaRecipeId"], parentColumns: ["id"], entity: PizzaRecipe)
  ]
)
class RecipeStep {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int pizzaRecipeId;
  final String name;
  final String waitDescription;
  final String waitUnit;
  final int waitMin;
  final int waitMax;
  late int waitValue;
  final String description;

  // final List<RecipeSubStep> subSteps;

  RecipeStep(this.pizzaRecipeId, this.name, this.description, this.waitDescription, this.waitUnit, this.waitMin, this.waitMax, {this.id}) {
    waitValue = waitMin;
  }

  Future<void> insert() async {
    final database = await getDatabase();
    final recipeStepDao = database.recipeStepDao;
    await recipeStepDao.insertRecipeStep(this);
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

  static Future<List<RecipeStep>> getRecipeStepForRecipe(PizzaRecipe pizzaRecipe) async {
    final database = await getDatabase();
    final recipeStepDao = database.recipeStepDao;
    return recipeStepDao.getPizzaRecipeSteps(pizzaRecipe.id!);
  }
}