import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

@dao
abstract class IngredientDao {
  @Query("SELECT * FROM Ingredient")
  Future<List<Ingredient>> getAllIngredients();

  @Query("SELECT * FROM Ingredient WHERE id = :id")
  Stream<Ingredient?> findIngredientById(int id);

  @insert
  Future<void> insertIngredient(Ingredient ingredient);
}