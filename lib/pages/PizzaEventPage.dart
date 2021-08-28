import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/main.dart';
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
                flex: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(this.widget.pizzaEvent.name),
                    Text("$completedRecipeStepCount/$recipeStepCount")
                  ],
                ),
              ),
              Divider(),
              Expanded(
                flex: 80,
                child: ListView(
                    children: <Widget>[
                      MarkdownBody(
                        data: this.widget.pizzaEvent.recipe.description,
                        onTapLink: (text, url, title) {
                          launch(url!);
                        },
                      ),
                      Divider(),
                      this.widget.pizzaEvent.recipe.getIngredientsTable(this.widget.pizzaEvent.pizzaCount, this.widget.pizzaEvent.doughBallSize),
                    ] + this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => buildRecipeStepWhenWidget(recipeStep)).toList()
                )
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
          )
        )
    );
  }
  
  Widget buildRecipeStepWhenWidget(RecipeStep recipeStep){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(recipeStep.name),
        // TODO add when todo/when completed
        Icon(recipeStep.completed ? FontAwesome5.check : FontAwesome5.clock)
      ],
    );
  }
}