
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/main.dart';
import 'package:timezone/timezone.dart' as tz;

part 'pizza_event.g.dart';

@HiveType(typeId: 4)
class PizzaEvent extends HiveObject{
  static const String hiveName = "PizzaEvent";
  
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
  
  @HiveField(5)
  bool archived = false;
  
  @HiveField(6)
  bool deleted = false;

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
        ticker: "ticker",
        fullScreenIntent: true,
    );

    const platformChannelSpecific = NotificationDetails(android: androidPlatformChannelSpecifics);

    var stepTime = tz.TZDateTime.from(dateTime, tz.local);
    final durationToFirstStep = Duration(seconds: recipe.recipeSteps
        .map((recipeStep) => recipeStep.getCurrentWaitInSeconds())
        .fold(0, (a, b) => a+b));
    stepTime = stepTime.subtract(durationToFirstStep);

    final List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final int notificationId = pendingNotificationRequests.map((pendingNotification) => pendingNotification.id).fold(0, max);

    int stepId = 0;
    for (final recipeStep in recipe.recipeSteps) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId+stepId,
          recipeStep.name,
          null,
          stepTime,
          platformChannelSpecific,
          androidAllowWhileIdle: true,
          payload: "${key}__$stepId",
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime
      );
      recipeStep.notificationId = notificationId;
      recipeStep.dateTime = stepTime;
      stepTime = stepTime.add(Duration(seconds: recipeStep.getCurrentWaitInSeconds()));
      stepId++;
    }
  }
  
  Future<void> cancelNotifications() async {
    for(final recipeStep in recipe.recipeSteps){
      flutterLocalNotificationsPlugin.cancel(recipeStep.notificationId);
    }
  }
}