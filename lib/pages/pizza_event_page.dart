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

  const PizzaEventPage(this.pizzaEvent);

  @override
  PizzaEventPageState createState() => PizzaEventPageState();
}

class PizzaEventPageState extends State<PizzaEventPage> {

  @override
  Widget build(BuildContext context) {
    final recipeStepCount = widget.pizzaEvent.recipe.recipeSteps.length;
    final completedRecipeStepCount = widget.pizzaEvent.recipe.recipeSteps.where((recipeStep) => recipeStep.completed).length;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.pizzaEvent.name),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 15,
                child: Column(
                  children: <Widget>[
                    Text(widget.pizzaEvent.name),
                    Text(getTimeRemainingString(widget.pizzaEvent.dateTime)),
                    Container(
                        color: Colors.blue,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/recipe/view", arguments: widget.pizzaEvent.recipe);
                          },
                          child: Text(widget.pizzaEvent.recipe.name, style: const TextStyle(color: Colors.white)),
                        )
                    )
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                flex: 80,
                child: ListView(
                    children: <Widget>[
                      const Center(
                          child: Text("Ingredients")
                      ),
                      Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(3),
                          3: FlexColumnWidth(),
                        },
                        children: <TableRow>[
                          const TableRow(
                              children: <TableCell>[
                                TableCell(child: Text("Ingredient")),
                                TableCell(child: Text("Total")),
                                TableCell(child: Center(child: Text("Bought")))
                              ]
                          )
                        ] + widget.pizzaEvent.recipe.ingredients.map((ingredient) => buildIngredientWidget(ingredient)).toList(),
                      ),
                      Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(),
                        },
                        children: <TableRow>[
                          TableRow(
                              children: <TableCell>[
                                const TableCell(child: Text("Recipe Step")),
                                const TableCell(child: Text("When")),
                                TableCell(child: Text("$completedRecipeStepCount/$recipeStepCount")),
                              ]
                          )
                        ] + widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => buildRecipeStepWhenWidget(recipeStep)).toList()
                      ),
                      const Divider(),
                    ] 
                )
              ),
            ],
          )
        )
    );
  }
  
  TableRow buildIngredientWidget(Ingredient ingredient){
    final int totalWeight = widget.pizzaEvent.pizzaCount * widget.pizzaEvent.doughBallSize;
    return TableRow(
      children: <TableCell>[
        TableCell(child: Text(ingredient.name)),
        TableCell(child: Text("${ingredient.getAbsoluteString(totalWeight)}${ingredient.unit}")),
        TableCell(child: Center(child: Checkbox(
          value: ingredient.bought,
          onChanged: (bool? newValue) {
            setState((){ingredient.bought = newValue!;});
            widget.pizzaEvent.save();
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