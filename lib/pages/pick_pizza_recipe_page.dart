import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/nav_drawer.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';

class PickPizzaRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
        title: const Text("Pick Recipe"),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<PizzaRecipe>("PizzaRecipes").listenable(),
            builder: (context, Box<PizzaRecipe> pizzaRecipesBox, widget) {
              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: pizzaRecipesBox.length,
                itemBuilder: (context, i) {
                  final pizzaRecipe = pizzaRecipesBox.get(i);
                  if (pizzaRecipe == null){
                    return const SizedBox();
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/event/add", arguments: pizzaRecipe);
                    },
                    child: PizzaRecipeWidget(pizzaRecipe),
                  );
                },
                separatorBuilder: (BuildContext context, int i) => const Divider(),
              );
            }
        ),
    );
  }
}