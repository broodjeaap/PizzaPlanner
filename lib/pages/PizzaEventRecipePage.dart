import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:url_launcher/url_launcher.dart';

class PizzaEventRecipePage extends StatefulWidget {
  final PizzaEvent pizzaEvent;
  PizzaEventRecipePage(this.pizzaEvent);
  
  @override
  PizzaEventRecipePageState createState() => PizzaEventRecipePageState();
}

class PizzaEventRecipePageState extends State<PizzaEventRecipePage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pizza Event Recipe"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
        child:  Column(
          children: <Widget>[
            Text(this.widget.pizzaEvent.name)
          ],
        )
      )
    );
  }

  Widget buildRecipeStep(RecipeStep recipeStep) {
    var subSteps = recipeStep.subSteps.length == 0 ? 1 : recipeStep.subSteps.length;

    var currentSubStep = recipeStep.subSteps.indexWhere((subStep) => subStep.completed);
    if (currentSubStep == -1){
      currentSubStep = 0;
    }

    var completedSubSteps = recipeStep.completed ? 1 : 0;
    if (recipeStep.subSteps.length > 0){
      completedSubSteps = currentSubStep + 1;
    }

    return Column(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(recipeStep.name),
              Text("$completedSubSteps/$subSteps")
            ],
          ),
        ),
        Expanded(
          flex: 80,
          child: ListView(
              children: <Widget>[
                MarkdownBody(
                  data: recipeStep.description,
                  onTapLink: (text, url, title) {
                    launch(url!);
                  },
                ),
              ]
          ),
        ),
        Expanded(
            flex: 10,
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.blue,
                child: TextButton(
                  child: Text("Start", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pushNamed(context, "/event/recipe", arguments: this.widget.pizzaEvent);
                  },
                )
            )
        ),
      ],
    );
  }
}