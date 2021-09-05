import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/nav_drawer.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';

class RecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
        title: const Text("Pizza Recipes"),
        body: Column(
            children: <Widget>[
              const Expanded(
                  flex: 5,
                  child: Text("Search here maybe")
              ),
              Container(
                  color: Colors.blue,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, "/recipes/add");
                    },
                    child: const Text("New Recipe", style: TextStyle(color: Colors.white)),
                  )
              ),
              const Divider(),
              const Center(child: Text("Long press to edit")),
              const Divider(),
              Expanded(
                flex: 50,
                child: ValueListenableBuilder(
                    valueListenable: Hive.box<PizzaRecipe>("PizzaRecipes").listenable(),
                    builder: (context, Box<PizzaRecipe> pizzaRecipesBox, widget) {
                      return ListView.separated(
                        itemCount: pizzaRecipesBox.length,
                        itemBuilder: (context, i) {
                          final pizzaRecipe = pizzaRecipesBox.get(i);
                          if (pizzaRecipe == null){
                            return const SizedBox();
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/recipe/view", arguments: pizzaRecipe);
                            },
                            onLongPress: () {
                              Navigator.pushNamed(context, "/recipes/add", arguments: pizzaRecipe);
                            },
                            child: PizzaRecipeWidget(pizzaRecipe),
                          );
                        },
                        separatorBuilder: (BuildContext context, int i) => const Divider(),
                      );
                    }
                ),
              )
            ]
        ),
    );
  }
}