import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/pages/AddPizzaEventPage.dart';
import 'package:pizzaplanner/pages/PizzaEventsPage.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/util.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(PizzaRecipeAdapter());
  Hive.registerAdapter(RecipeStepAdapter());
  Hive.registerAdapter(RecipeSubStepAdapter());
  Hive.registerAdapter(IngredientAdapter());
  Hive.registerAdapter(PizzaEventAdapter());

  await Hive.openBox<PizzaEvent>("PizzaEvents");
  var pizzaRecipesBox = await Hive.openBox<PizzaRecipe>("PizzaRecipes");

  if (pizzaRecipesBox.isEmpty){
    pizzaRecipesBox.addAll(await getRecipes());
  }

  runApp(PizzaPlanner());

  //await Hive.close();
}

class PizzaPlanner extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PizzaPlanner",
      home: PizzaEventsPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case "/": {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
      case "/add": {
        return MaterialPageRoute(builder: (context) => AddPizzaEventPage());
      }

      default: {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
    }
  }
}