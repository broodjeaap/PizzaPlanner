import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/main.dart';

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
          InkWell(
            onLongPress: () {
              setState(() {
                recipeStep.completedOn = recipeStep.completed ? null : DateTime.now();
              });
            },
            child: Container(
              width: double.infinity,
              color: recipeStep.completed ? Colors.green : Colors.grey,
              child: Column(
                children: <Widget>[
                  Text(recipeStep.description)
                ],
              ),
            ),
          ),
          Divider(),
        ]
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
          Column(
              children: recipeStep.subSteps.map(
                      (subStep) => getSubStepWidget(subStep)
              ).expand((subStep) => [Divider(), subStep]).toList()
          )
        ]
    );
  }

  Widget getSubStepWidget(RecipeSubStep recipeSubStep){
    return InkWell(
      onLongPress: () async {},
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return SubStepDialog(recipeSubStep);
          }
        );
        setState(() {});
      },
      child: Container(
        color: recipeSubStep.completed ? Colors.green : Colors.grey,
        child: Column(
          children: <Widget>[
            Center(
              child: Text(recipeSubStep.name),
            ),
            Text(recipeSubStep.description)
          ],
        ),
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
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Container(
                          color: Colors.grey,
                          child: TextButton(
                            child: Text("Notify!", style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              const androidPlatformChannelSpecifics = AndroidNotificationDetails(
                                "PizzaEvent", "PizzaEvent", "PizzaEvent notifications",
                                importance: Importance.max,
                                priority: Priority.high,
                                ticker: "ticker"
                              );
                              const platformChannelSpecific = NotificationDetails(android: androidPlatformChannelSpecifics);
                              await flutterLocalNotificationsPlugin.show(
                                  0, 'test', 'teeest', platformChannelSpecific,
                                  payload: "payload123");
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