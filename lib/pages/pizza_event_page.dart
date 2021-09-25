import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/pages/recipe_page.dart';
import 'package:pizzaplanner/pages/recipe_step_instruction_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/util.dart';

class PizzaEventPage extends StatefulWidget {
  static const String route = "/event/view";
  
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
    
    RecipeStep? firstStepDue;
    for (final recipeStep in widget.pizzaEvent.recipe.recipeSteps){
      if (recipeStep.completed){
        continue;
      }
      if (recipeStep.dateTime.isAfter(DateTime.now())){
        continue;
      }
      firstStepDue = recipeStep;
      break;
    }
    
    return PizzaPlannerScaffold(
        title: Text(widget.pizzaEvent.name),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 15,
              child: Column(
                children: <Widget>[
                  Text(
                    getTimeRemainingString(widget.pizzaEvent.dateTime),
                    style: Theme.of(context).textTheme.subtitle1
                  ),
                  Container(
                      color: Theme.of(context).buttonColor,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RecipePage.route, arguments: widget.pizzaEvent.recipe);
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
                          TableRow(
                              children: <TableCell>[
                                TableCell(child: Text("Ingredient", style: Theme.of(context).textTheme.bodyText1)),
                                TableCell(child: Text("Total", style: Theme.of(context).textTheme.bodyText1)),
                                TableCell(child: Center(child: Text("Bought", style: Theme.of(context).textTheme.bodyText1)))
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
                                  TableCell(child: Text("Recipe Step", style: Theme.of(context).textTheme.bodyText1)),
                                  TableCell(child: Text("When", style: Theme.of(context).textTheme.bodyText1)),
                                  TableCell(child: Text("$completedRecipeStepCount/$recipeStepCount", style: Theme.of(context).textTheme.bodyText1)),
                                ]
                            )
                          ] + widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => buildRecipeStepWhenWidget(recipeStep)).toList()
                      ),
                      const Divider(),
                      if (firstStepDue != null) Container(
                          color: Theme.of(context).buttonColor,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context,
                                RecipeStepInstructionPage.route,
                                arguments: RecipeStepInstructionPageArguments(
                                    widget.pizzaEvent,
                                    firstStepDue!
                                )
                            ).then((_) => setState((){}));
                          },
                          child: Text("Start '${firstStepDue.name}' now!", style: const TextStyle(color: Colors.white))
                        )
                      ) else const SizedBox()
                    ]
                )
            ),
          ],
        ),
    );
  }
  
  TableRow buildIngredientWidget(Ingredient ingredient){
    final int totalWeight = widget.pizzaEvent.pizzaCount * widget.pizzaEvent.doughBallSize;
    return TableRow(
      children: <TableCell>[
        TableCell(child: Text(ingredient.name)),
        TableCell(child: Text("${ingredient.getAbsoluteString(totalWeight)}${ingredient.unit}")),
        TableCell(child: Center(child: Checkbox(
          activeColor: Theme.of(context).primaryColor,
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