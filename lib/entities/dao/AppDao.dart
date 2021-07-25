import 'package:pizzaplanner/entities/PizzaDatabase.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/util.dart';


class AppDao {
  static const DATABASE_PATH = "pizza.db";

  static Future<List<PizzaRecipe>> getPizzaRecipes() async {
    final database = await $FloorPizzaDatabase.databaseBuilder(DATABASE_PATH).build();
    final pizzaRecipeDao = database.pizzaRecipeDao;
    final recipeStepDao = database.recipeStepDao;
    final recipeSubStepDao = database.recipeSubStepDao;
    final ingredientDao = database.ingredientDao;

    List<PizzaRecipe> pizzaRecipes = await pizzaRecipeDao.getAllPizzaRecipes();

    if (pizzaRecipes.isEmpty){
      await loadYamlRecipesIntoDb();
      pizzaRecipes = await pizzaRecipeDao.getAllPizzaRecipes();
    }

    for (var pizzaRecipe in pizzaRecipes) {
      pizzaRecipe.ingredients = await ingredientDao.getPizzaRecipeIngredients(pizzaRecipe.id!);
      print(pizzaRecipe.ingredients);
      pizzaRecipe.recipeSteps = await recipeStepDao.getPizzaRecipeSteps(pizzaRecipe.id!);
      print(pizzaRecipe.recipeSteps);
      for (var pizzaRecipeStep in pizzaRecipe.recipeSteps){
        pizzaRecipeStep.subSteps = await recipeSubStepDao.getRecipeStepSubSteps(pizzaRecipeStep.id!);
        print(pizzaRecipeStep.subSteps);
      }
    }

    return pizzaRecipes;
  }


}