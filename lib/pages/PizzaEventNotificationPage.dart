import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';

class PizzaEventNotificationPage extends StatefulWidget {
  final String? payload;

  PizzaEventNotificationPage(this.payload);

  @override
  PizzaEventNotificationState createState() => PizzaEventNotificationState();
}

class PizzaEventNotificationState extends State<PizzaEventNotificationPage> {
  late final PizzaEvent pizzaEvent;
  late final RecipeStep recipeStep;

  @override
  void initState() {
    super.initState();
    if (this.widget.payload == null){
      print("Redirected to notification page but no payload... Popping");
      Navigator.pop(context);
    }
    var split = this.widget.payload!.split("__");
    var pizzaEventId = int.parse(split[0]);
    var recipeStepId = int.parse(split[1]);

    var pizzaEventsBox = Hive.box<PizzaEvent>("PizzaEvents");

    pizzaEvent = pizzaEventsBox.get(pizzaEventId)!;
    recipeStep = pizzaEvent.recipe.recipeSteps[recipeStepId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("From notification"),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child:  Column(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: Text(pizzaEvent.name),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Center(
                        child: Text(recipeStep.name)
                    ),
                  ),
                  Divider(),
                  Expanded(
                      flex: 10,
                      child: Container(
                          color: Colors.blue,
                          width: double.infinity,
                          child: TextButton(
                            child: Text("Ignore", style: TextStyle(color: Colors.white)),
                            onPressed: () async {

                            },
                          )
                      )
                  ),
                  Divider(),
                  Expanded(
                      flex: 30,
                      child: Container(
                          color: Colors.blue,
                          width: double.infinity,
                          child: TextButton(
                            child: Text("Snooze 15 minutes", style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              
                            },
                          )
                      )
                  ),
                  Divider(),
                  Expanded(
                      flex: 40,
                      child: Container(
                          color: Colors.blue,
                          width: double.infinity,
                          child: TextButton(
                            child: Text("Start!", style: TextStyle(color: Colors.white)),
                            onPressed: () async {

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