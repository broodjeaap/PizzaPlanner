import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';

class RecipeStepInstructionPageArguments {
  final PizzaEvent pizzaEvent;
  final RecipeStep recipeStep;

  RecipeStepInstructionPageArguments(this.pizzaEvent, this.recipeStep);
}

class RecipeStepInstructionPage extends StatefulWidget {
  late final PizzaEvent pizzaEvent;
  late final RecipeStep recipeStep;

  RecipeStepInstructionPage(RecipeStepInstructionPageArguments arguments) {
    this.pizzaEvent = arguments.pizzaEvent;
    this.recipeStep = arguments.recipeStep;
  }


  @override
  RecipeStepInstructionState createState() => RecipeStepInstructionState();
}

class RecipeStepInstructionState extends State<RecipeStepInstructionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("From notification"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
        child:  ListView(
          children: <Widget>[
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(this.widget.recipeStep.name),

                ],
              ),
              children: <Widget>[
                
              ],
            )
          ]
        )
      )
    );
  }
}