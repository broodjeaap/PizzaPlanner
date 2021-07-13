import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';

@dao
abstract class RecipeStepDao {
  @Query("SELECT * FROM RecipeStep")
  Future<List<RecipeStep>> getAllRecipeSteps();

  @Query("SELECT * FROM RecipeStep WHERE id = :id")
  Stream<RecipeStep?> findRecipeStepById(int id);

  @insert
  Future<void> insertRecipeStep(RecipeStep recipeStep);
}