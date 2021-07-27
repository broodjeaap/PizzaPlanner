import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';

class PizzaEventPage extends StatefulWidget {
  PizzaEvent pizzaEvent;

  PizzaEventPage(this.pizzaEvent);

  @override
  PizzaEventPageState createState() => PizzaEventPageState();
}

class PizzaEventPageState extends State<PizzaEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.pizzaEvent.name),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) {
              return ExpansionTile(
                title: Row(
                  children: [],
                ),
                children: recipeStep.subSteps.map((recipeSubStep) {
                    return Text(recipeSubStep.name);
                  }
                ).toList(),
              );
            }).toList(),
          )
        )
    );
  }
}