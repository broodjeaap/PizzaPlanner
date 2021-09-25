import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';

class PizzaRecipeWidget extends StatelessWidget {
  final PizzaRecipe pizzaRecipe;

  const PizzaRecipeWidget(this.pizzaRecipe);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (pizzaRecipe.imgUrl != null)
                Image.network(pizzaRecipe.imgUrl!)
              else
                const Icon(FontAwesome5.pizza_slice, size: 100, color: Color.fromARGB(100, 150, 150, 150)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(pizzaRecipe.name, style: Theme.of(context).textTheme.headline5),
                  ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${pizzaRecipe.getMinDuration().inHours.round()} to ${pizzaRecipe.getMaxDuration().inHours.round()} hours",
                      style: Theme.of(context).textTheme.subtitle1
                    )
                  ]
              )
            ]
        )
    );
  }
}