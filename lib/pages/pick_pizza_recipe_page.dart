import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/widgets/PizzaRecipeWidget.dart';

class PickPizzaRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Pizza Recipe"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<PizzaRecipe>("PizzaRecipes").listenable(),
          builder: (context, Box<PizzaRecipe> pizzaRecipesBox, widget) {
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: pizzaRecipesBox.length,
              itemBuilder: (context, i) => PizzaRecipeWidget(pizzaRecipesBox.getAt(i)!),
              separatorBuilder: (BuildContext context, int i) => const Divider(),
            );
          }
        )
      )
    );
  }
}