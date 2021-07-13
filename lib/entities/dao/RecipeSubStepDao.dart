import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';

@dao
abstract class RecipeSubStepDao {
  @Query("SELECT * FROM RecipeSubStep")
  Future<List<RecipeSubStep>> getAllRecipeSubSteps();

  @Query("SELECT * FROM RecipeSubStep WHERE id = :id")
  Stream<RecipeSubStep?> findRecipeSubStepById(int id);

  @insert
  Future<void> insertRecipeSubStep(RecipeSubStep recipeSubStep);
}