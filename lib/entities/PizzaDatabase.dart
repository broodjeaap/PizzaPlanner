import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/entities/dao/IngridientDao.dart';
import 'package:pizzaplanner/entities/dao/PizzaEventDoa.dart';
import 'package:pizzaplanner/entities/dao/PizzaRecipeDao.dart';
import 'package:pizzaplanner/entities/dao/RecipeStepDao.dart';
import 'package:pizzaplanner/entities/dao/RecipeSubStepDao.dart';

part 'PizzaDatabase.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [PizzaEvent, PizzaRecipe, RecipeStep, RecipeSubStep, Ingredient])
abstract class PizzaDatabase extends FloorDatabase {
  PizzaEventDoa get pizzaEventDoa;
  PizzaRecipeDao get pizzaRecipeDao;
  RecipeStepDao get recipeStepDao;
  RecipeSubStepDao get recipeSubStepDao;
  IngredientDao get ingredientDao;
}

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}