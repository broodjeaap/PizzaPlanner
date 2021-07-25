import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';

class PizzaRecipeWidget extends StatelessWidget {
  final PizzaRecipe pizzaRecipe;

  PizzaRecipeWidget(this.pizzaRecipe);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text(pizzaRecipe.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${pizzaRecipe.getMinDuration().inHours.round()} to ${pizzaRecipe.getMaxDuration().inHours.round()} hours")
              ]
            )
          ]
        )
      )
    );
  }
}