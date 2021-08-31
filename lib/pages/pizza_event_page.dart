import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/main.dart';
import 'package:pizzaplanner/util.dart';
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PizzaEventPage extends StatefulWidget {
  final PizzaEvent pizzaEvent;

  PizzaEventPage(this.pizzaEvent);

  @override
  PizzaEventPageState createState() => PizzaEventPageState();
}

class PizzaEventPageState extends State<PizzaEventPage> {

  @override
  Widget build(BuildContext context) {
    var recipeStepCount = this.widget.pizzaEvent.recipe.recipeSteps.length;
    var completedRecipeStepCount = this.widget.pizzaEvent.recipe.recipeSteps.where((recipeStep) => recipeStep.completed).length;
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.pizzaEvent.name),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 15,
                child: Column(
                  children: <Widget>[
                    Text(this.widget.pizzaEvent.name),
                    Text(getTimeRemainingString(this.widget.pizzaEvent.dateTime)),
                    Container(
                        color: Colors.blue,
                        child: TextButton(
                          child: Text(this.widget.pizzaEvent.recipe.name, style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.pushNamed(context, "/event/recipe", arguments: this.widget.pizzaEvent);
                          },
                        )
                    )
                  ],
                ),
              ),
              Divider(),
              Expanded(
                flex: 80,
                child: ListView(
                    children: <Widget>[
                      Center(
                          child: Text("Ingredients")
                      ),
                      Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(3),
                          3: FlexColumnWidth(1),
                        },
                        children: <TableRow>[
                          TableRow(
                              children: <TableCell>[
                                TableCell(child: Text("Ingredient")),
                                TableCell(child: Text("Total")),
                                TableCell(child: Center(child: Text("Bought")))
                              ]
                          )
                        ] + this.widget.pizzaEvent.recipe.ingredients.map((ingredient) => buildIngredientWidget(ingredient)).toList(),
                      ),
                      Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(1),
                        },
                        children: <TableRow>[
                          TableRow(
                              children: <TableCell>[
                                TableCell(child: Text("Recipe Step")),
                                TableCell(child: Text("When")),
                                TableCell(child: Text("$completedRecipeStepCount/$recipeStepCount")),
                              ]
                          )
                        ] + this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => buildRecipeStepWhenWidget(recipeStep)).toList()
                      ),
                      Divider(),
                    ] 
                )
              ),
            ],
          )
        )
    );
  }
  
  TableRow buildIngredientWidget(Ingredient ingredient){
    int totalWeight = this.widget.pizzaEvent.pizzaCount * this.widget.pizzaEvent.doughBallSize;
    return TableRow(
      children: <TableCell>[
        TableCell(child: Text(ingredient.name)),
        TableCell(child: Text("${ingredient.getAbsoluteString(totalWeight)}${ingredient.unit}")),
        TableCell(child: Center(child: Checkbox(
          value: ingredient.bought,
          onChanged: (bool? newValue) {
            setState((){ingredient.bought = newValue!;});
            this.widget.pizzaEvent.save();
          },
        ))),
      ]
    );
  }
  
  TableRow buildRecipeStepWhenWidget(RecipeStep recipeStep){
    return TableRow(
        children: <TableCell>[
          TableCell(child: Text(recipeStep.name)),
          TableCell(child: Text(getDateFormat().format(recipeStep.dateTime))),
          TableCell(child: Center(child: Icon(recipeStep.completed ? FontAwesome5.check : FontAwesome5.clock))),
        ]
    );
  }
}