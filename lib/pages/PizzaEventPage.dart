import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';

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
            children: this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => PizzaEventRecipeStepWidget(recipeStep)).toList()
          )
        )
    );
  }

  triggerSetState() => setState(() {});
}

class PizzaEventRecipeStepWidget extends StatefulWidget {
  final RecipeStep recipeStep;

  PizzaEventRecipeStepWidget(this.recipeStep);

  PizzaEventRecipeStepWidgetState createState() => PizzaEventRecipeStepWidgetState();
}

class PizzaEventRecipeStepWidgetState extends State<PizzaEventRecipeStepWidget> {
  @override
  Widget build(BuildContext context) {
    return this.widget.recipeStep.subSteps.length > 0 ?
      buildPizzaEventRecipeStepWidgetWithSubSteps() :
      buildPizzaEventRecipeStepWidgetWithoutSubSteps();
  }

  Widget buildPizzaEventRecipeStepWidgetWithSubSteps() {
    int recipeSubStepsCompleted = this.widget.recipeStep.subSteps.where((subStep) => subStep.completed).length;
    int recipeSubSteps = this.widget.recipeStep.subSteps.length;
    return ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(FontAwesome5.sitemap),
            Text(this.widget.recipeStep.name),
            Text("$recipeSubStepsCompleted/$recipeSubSteps")
          ],
        ),
        children: <Widget>[
          Text(this.widget.recipeStep.description),

        ] + this.widget.recipeStep.subSteps.map((subStep) => PizzaEventSubStepWidget(subStep)).toList() //subStep.buildPizzaEventSubStepWidget(context, pizzaEventPage)).toList()
    );
  }

  Widget buildPizzaEventRecipeStepWidgetWithoutSubSteps() {
    return ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(FontAwesome5.sitemap),
            Text(this.widget.recipeStep.name),
            Text("${this.widget.recipeStep.completedOn == null ? 0 : 1}/1")
          ],
        ),
        children: <Widget>[
          Text(this.widget.recipeStep.description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(this.widget.recipeStep.name),
              Checkbox(
                value: this.widget.recipeStep.completedOn != null,
                onChanged: (bool? newValue) async {
                  if (newValue == null){
                    return;
                  }
                  this.widget.recipeStep.completedOn = newValue ? DateTime.now() : null;
                  setState(() {});
                },
              )
            ],
          )
        ]
    );
  }
}

class PizzaEventSubStepWidget extends StatefulWidget {
  final RecipeSubStep recipeSubStep;

  PizzaEventSubStepWidget(this.recipeSubStep);

  PizzaEventSubStepWidgetState createState() => PizzaEventSubStepWidgetState();
}

class PizzaEventSubStepWidgetState extends State<PizzaEventSubStepWidget> {
  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return PizzaEventSubStepDialog(this.widget.recipeSubStep);
          }
        );
        setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(this.widget.recipeSubStep.name),
          IgnorePointer(
            child: Checkbox(
              value: this.widget.recipeSubStep.completed,
              onChanged: (b) {},
            )
          )
        ],
      ),
    );
  }
}

class PizzaEventSubStepDialog extends StatefulWidget {
  final RecipeSubStep recipeSubStep;

  PizzaEventSubStepDialog(this.recipeSubStep);

  PizzaEventSubStepDialogState createState() => PizzaEventSubStepDialogState();
}

class PizzaEventSubStepDialogState extends State<PizzaEventSubStepDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.all(10),
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
                children: <Widget>[
                  Text(this.widget.recipeSubStep.name),
                  Text(this.widget.recipeSubStep.description),
                  Expanded(
                      child: Container()
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Container(
                          color: this.widget.recipeSubStep.completed ? Colors.green : Colors.redAccent,
                          child: TextButton(
                            child: Text(this.widget.recipeSubStep.completed ? "Complete" : "Todo", style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                this.widget.recipeSubStep.completedOn = this.widget.recipeSubStep.completed ? null : DateTime.now();
                              });
                            },
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}