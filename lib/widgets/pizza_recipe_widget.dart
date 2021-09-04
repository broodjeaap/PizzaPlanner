import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';

class PizzaRecipeWidget extends StatelessWidget {
  final PizzaRecipe pizzaRecipe;

  const PizzaRecipeWidget(this.pizzaRecipe);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/event/add", arguments: this.pizzaRecipe);
      },
      child: Container(
          height: 120,
          color: Colors.blueAccent,
          child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(pizzaRecipe.name),
                        ]
                    ),
                    Text(pizzaRecipe.getShortDescriptionString()),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("${pizzaRecipe.getMinDuration().inHours.round()} to ${pizzaRecipe.getMaxDuration().inHours.round()} hours")
                        ]
                    )
                  ]
              )
          )
      ),
    );
  }
}