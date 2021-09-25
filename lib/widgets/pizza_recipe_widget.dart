import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';

class PizzaRecipeWidget extends StatelessWidget {
  final PizzaRecipe pizzaRecipe;

  const PizzaRecipeWidget(this.pizzaRecipe);

  @override
  Widget build(BuildContext context) {
    return Container(
        //height: 120,
        //color: Colors.blueAccent,
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (pizzaRecipe.imgUrl != null) 
                    Image.network(pizzaRecipe.imgUrl!) 
                  else 
                    const Icon(FontAwesome5.pizza_slice, size: 100,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(pizzaRecipe.name),
                      ]
                  ),
                ]
            )
        )
    );
  }
}