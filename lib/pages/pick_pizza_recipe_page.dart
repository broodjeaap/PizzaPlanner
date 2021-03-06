import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/add_pizza_event_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';

class PickPizzaRecipePage extends StatelessWidget {
  static const String route = "/event/pick_recipe";
  
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
        title: const Text("Pick Recipe"),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<PizzaRecipe>(PizzaRecipe.hiveName).listenable(),
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
                      Navigator.pushNamed(context, AddPizzaEventPage.route, arguments: pizzaRecipe);
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