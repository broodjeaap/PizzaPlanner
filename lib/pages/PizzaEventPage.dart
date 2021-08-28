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
  late final PageController controller;

  @override
  void initState(){
    super.initState();
    // Set first page to the first recipeStep that's not completed
    int initialPage = this.widget.pizzaEvent.recipe.recipeSteps.indexWhere((recipeStep) => !(recipeStep.completed));
    this.controller = PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.pizzaEvent.name),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(10),
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: this.controller,
            children: this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => buildRecipeStep(recipeStep)).toList()
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
                MarkdownBody(data: recipeStep.description),
                Divider(),
              ] + recipeStep.subSteps.asMap().map<int, Widget>((index, subStep) => MapEntry(index, getSubStepWidget(subStep, index, currentSubStep))).values.toList()
            ),
        ),
        Expanded(
            flex: 10,
            child: SizedBox(
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 10,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.blue,
                          child: TextButton(
                            child: Text("Undo", style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              recipeStep.subSteps.map((subStep) => subStep.completedOn = null);
                              //controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                            },
                          )
                      )
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                      flex: 10,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.blue,
                          child: TextButton(
                            child: Text("Complete ->", style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              recipeStep.subSteps.where((recipeSubStep) => !(recipeSubStep.completed)).completeNow();
                              //recipeStep.completeStepNow();
                              //this.widget.pizzaEvent.save();
                              //controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
                            },
                          )
                      )
                  ),
                ],
              )
            )
        )
      ],
    );
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
        ]
    );
  }

  Widget getSubStepWidget(RecipeSubStep recipeSubStep, int index, int current){
    return ExpansionTile(
      initiallyExpanded: index == current,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(recipeSubStep.name),
          Icon(FontAwesome5.check, color: recipeSubStep.completed ? Colors.green : Colors.grey),
        ]
      ),
      children: <Widget>[
        MarkdownBody(
          data: recipeSubStep.description,
          onTapLink: (text, url, title) {
            launch(url!);
          },
        )
      ],
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
                  ),
                ]
            )
        )
    );
  }
}