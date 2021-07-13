import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

@dao
abstract class PizzaRecipeDao {
  @Query("SELECT * FROM PizzaRecipe")
  Future<List<PizzaRecipe>> getAllPizzaRecipes();

  @Query("SELECT * FROM PizzaRecipe WHERE id = :id")
  Stream<PizzaRecipe?> findPizzaRecipeById(int id);

  @insert
  Future<void> insertPizzaRecipe(PizzaRecipe pizzaRecipe);
}