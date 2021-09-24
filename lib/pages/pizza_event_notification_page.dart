import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/main.dart';
import 'package:pizzaplanner/pages/recipe_step_instruction_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:vibration/vibration.dart';



class PizzaEventNotificationPage extends StatefulWidget {
  static const String route = "/event/notification";
  final String? payload;

  const PizzaEventNotificationPage(this.payload);

  @override
  PizzaEventNotificationState createState() => PizzaEventNotificationState();
}

class PizzaEventNotificationState extends State<PizzaEventNotificationPage> {
  late final PizzaEvent pizzaEvent;
  late final RecipeStep recipeStep;

  @override
  void initState() {
    super.initState();
    if (widget.payload == null){
      Navigator.pop(context);
    }
    final split = widget.payload!.split("__");
    final pizzaEventId = int.parse(split[0]);
    final recipeStepId = int.parse(split[1]);

    final pizzaEventsBox = Hive.box<PizzaEvent>(PizzaEvent.hiveName);

    pizzaEvent = pizzaEventsBox.get(pizzaEventId)!;
    recipeStep = pizzaEvent.recipe.recipeSteps[recipeStepId];

    FlutterRingtonePlayer.stop();
    Vibration.cancel();
    
    FlutterRingtonePlayer.playNotification(looping: true);
    Vibration.hasVibrator().then((hasVibrator) {
      if(hasVibrator != null && hasVibrator){
        Vibration.vibrate(duration: 10000);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PizzaPlannerScaffold(
        title: Text(recipeStep.name),
        body: Column(
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
              const Divider(),
              Expanded(
                  flex: 10,
                  child: Container(
                      color: Colors.blue,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          showDialog(context: context, builder: (BuildContext context) {
                            return buildIgnoreDialog();
                          });
                        },
                        child: const Text("Ignore", style: TextStyle(color: Colors.white)),
                      )
                  )
              ),
              const Divider(),
              Expanded(
                  flex: 30,
                  child: Container(
                      color: Colors.blue,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          setRecipeStepNotification(DateTime.now().add(const Duration(minutes: 15)));
                          Navigator.pop(context);
                        },
                        onLongPress: () async {
                          final future5Min = DateTime.now().add(const Duration(minutes: 5));
                          DatePicker.showDateTimePicker(context,
                              minTime: future5Min,
                              currentTime: future5Min,
                              maxTime: DateTime.now().add(const Duration(days: 365*10)),
                              onConfirm: (newEventTime) {
                                setState((){
                                  setRecipeStepNotification(newEventTime);
                                  Navigator.pop(context);
                                });
                              }
                          );

                        },
                        child: const Text("Snooze 15 minutes", style: TextStyle(color: Colors.white)),
                      )
                  )
              ),
              const Divider(),
              Expanded(
                  flex: 40,
                  child: Container(
                      color: Colors.blue,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context,
                              RecipeStepInstructionPage.route,
                              arguments: RecipeStepInstructionPageArguments(
                                  pizzaEvent,
                                  recipeStep
                              )
                          );
                        },
                        child: const Text("Start!", style: TextStyle(color: Colors.white)),
                      )
                  )
              ),
            ]
        ),
    );
  }
  
  @override
  Future<void> dispose() async {
    FlutterRingtonePlayer.stop();
    Vibration.cancel();
    super.dispose();
  }

  AlertDialog buildIgnoreDialog(){
    return AlertDialog(
      title: const Text("This step will be marked as completed."),
      content: const Text("Instructions for this step can still be viewed on the Pizza Event page"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Back"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              recipeStep.completeStepNow();
            });
            pizzaEvent.save();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("Complete"),
        ),
      ]
    );
  }
  
  Future<void> setRecipeStepNotification(DateTime newTime) async {
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
        payload: widget.payload,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime
    );
    recipeStep.dateTime = newTime;
    pizzaEvent.save();
  }
}

