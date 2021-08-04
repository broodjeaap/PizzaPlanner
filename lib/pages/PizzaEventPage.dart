import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';

class PizzaEventPage extends StatefulWidget {
  final PizzaEvent pizzaEvent;

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
            children: this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => buildRecipeStepWidget(recipeStep)).toList()
          )
        )
    );
  }

  Widget buildRecipeStepWidget(RecipeStep recipeStep){
    return recipeStep.subSteps.length > 0 ?
      buildRecipeStepWidgetWithSubSteps(recipeStep) :
      buildRecipeStepWidgetWithoutSubSteps(recipeStep);
  }

  Widget buildRecipeStepWidgetWithSubSteps(RecipeStep recipeStep){
    int recipeSubStepsCompleted = recipeStep.subSteps.where((subStep) => subStep.completed).length;
    int recipeSubSteps = recipeStep.subSteps.length;
    return ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(FontAwesome5.sitemap),
            Text(recipeStep.name),
            Text("$recipeSubStepsCompleted/$recipeSubSteps")
          ],
        ),
        children: <Widget>[
          Text(recipeStep.description),
          Column(
              children: recipeStep.subSteps.map((subStep) => getSubStepWidget(subStep)).toList()
          )
        ]
    );
  }

  Widget buildRecipeStepWidgetWithoutSubSteps(RecipeStep recipeStep) {
    return ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(FontAwesome5.sitemap),
            Text(recipeStep.name),
            Text("${recipeStep.completedOn == null ? 0 : 1}/1")
          ],
        ),
        children: <Widget>[
          Text(recipeStep.description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(recipeStep.name),
              Checkbox(
                value: recipeStep.completedOn != null,
                onChanged: (bool? newValue) async {
                  if (newValue == null){
                    return;
                  }
                  setState(() {recipeStep.completedOn = newValue ? DateTime.now() : null;});
                },
              )
            ],
          ),
          Divider(),
        ]
    );
  }

  Widget getSubStepWidget(RecipeSubStep recipeSubStep){
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return SubStepDialog(recipeSubStep);
          }
        );
        setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 50,
              child: Container(
                color: recipeSubStep.completed ? Colors.green : Colors.grey,
                child: Center(
                    child: Text(recipeSubStep.name)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SubStepDialog extends StatefulWidget {
  final RecipeSubStep recipeSubStep;

  SubStepDialog(this.recipeSubStep);

  SubStepDialogState createState() => SubStepDialogState();
}

class SubStepDialogState extends State<SubStepDialog> {
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
                          color: this.widget.recipeSubStep.completed ? Colors.green : Colors.grey,
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