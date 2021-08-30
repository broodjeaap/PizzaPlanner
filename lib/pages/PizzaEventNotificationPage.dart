import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/main.dart';
import 'package:pizzaplanner/pages/RecipeStepInstructionPage.dart';

import 'package:timezone/timezone.dart' as tz;



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
                              showDialog(context: context, builder: (BuildContext context) {
                                return buildIgnoreDialog();
                              });
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
                              setRecipeStepNotificatcion(DateTime.now().add(const Duration(minutes: 15)));
                              Navigator.pop(context);
                            },
                            onLongPress: () async {
                              var future5Min = DateTime.now().add(Duration(minutes: 5));
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: future5Min,
                                  currentTime: future5Min,
                                  maxTime: DateTime.now().add(Duration(days: 365*10)),
                                  onConfirm: (newEventTime) {
                                    setState((){
                                      setRecipeStepNotificatcion(newEventTime);
                                      Navigator.pop(context);
                                    });
                                  }
                              );
                              
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
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context,
                                  "/event/recipe_step",
                                  arguments: RecipeStepInstructionPageArguments(
                                      pizzaEvent,
                                      recipeStep
                                  )
                              );
                            },
                          )
                      )
                  ),
                ]
            )
        )
    );
  }

  AlertDialog buildIgnoreDialog(){
    return AlertDialog(
      title: Text("This step will be marked as completed."),
      content: Text("Instructions for this step can still be viewed on the Pizza Event page"),
      actions: <Widget>[
        TextButton(
          child: Text("Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Complete"),
          onPressed: () {
            setState(() {
              recipeStep.completeStepNow();
            });
            pizzaEvent.save();
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ]
    );
  }
  
  void setRecipeStepNotificatcion(DateTime newTime) async {
    flutterLocalNotificationsPlugin.cancel(recipeStep.notificationId);

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "PizzaEventChannel", "PizzaEventChannel", "PizzaPlanner notification channel",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
      fullScreenIntent: true,
    );
    const platformChannelSpecific = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        recipeStep.notificationId,
        recipeStep.name,
        null,
        tz.TZDateTime.from(newTime, tz.local),
        platformChannelSpecific,
        androidAllowWhileIdle: true,
        payload: this.widget.payload,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime
    );
    recipeStep.dateTime = newTime;
    pizzaEvent.save();
  }
}

