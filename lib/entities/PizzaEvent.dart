
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/main.dart';

import 'package:timezone/timezone.dart' as tz;

part 'PizzaEvent.g.dart';

@HiveType(typeId: 4)
class PizzaEvent extends HiveObject{
  @HiveField(0)
  String name;

  @HiveField(1)
  PizzaRecipe recipe;

  @HiveField(2)
  int pizzaCount;

  @HiveField(3)
  int doughBallSize;

  @HiveField(4)
  DateTime dateTime;

  PizzaEvent(
    this.name,
    this.recipe,
    this.pizzaCount,
    this.doughBallSize,
    this.dateTime
  );

  Future<void> createPizzaEventNotifications() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "PizzaEventChannel", "PizzaEventChannel", "PizzaPlanner notification channel",
        importance: Importance.max,
        priority: Priority.high,
        ticker: "ticker"
    );

    const platformChannelSpecific = NotificationDetails(android: androidPlatformChannelSpecifics);

    var stepTime = tz.TZDateTime.from(dateTime, tz.local);
    var durationToFirstStep = Duration(seconds: this.recipe.recipeSteps
        .map((recipeStep) => recipeStep.getCurrentWaitInSeconds())
        .fold(0, (a, b) => a+b));
    stepTime = stepTime.subtract(durationToFirstStep);

    for (var recipeStep in this.recipe.recipeSteps) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          "${name}_${recipeStep.name}_${dateTime.millisecondsSinceEpoch}".hashCode,
          recipeStep.name,
          null,
          stepTime,
          platformChannelSpecific,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime
      );
      stepTime = stepTime.add(Duration(seconds: recipeStep.getCurrentWaitInSeconds()));
    }
  }
}