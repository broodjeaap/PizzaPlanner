import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';
import 'package:pizzaplanner/pages/AddPizzaEventPage.dart';
import 'package:pizzaplanner/pages/PickPizzaRecipePage.dart';
import 'package:pizzaplanner/pages/PizzaEventPage.dart';
import 'package:pizzaplanner/pages/PizzaEventsPage.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/util.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  // hive init
  await Hive.initFlutter();

  Hive.registerAdapter(PizzaEventAdapter());
  Hive.registerAdapter(PizzaRecipeAdapter());
  Hive.registerAdapter(RecipeStepAdapter());
  Hive.registerAdapter(RecipeSubStepAdapter());
  Hive.registerAdapter(IngredientAdapter());

  await Hive.openBox<PizzaEvent>("PizzaEvents");
  var pizzaRecipesBox = await Hive.openBox<PizzaRecipe>("PizzaRecipes");

  if (pizzaRecipesBox.isEmpty){
    print("Load pizzas from yamls");
    pizzaRecipesBox.addAll(await getRecipes());
  }

  // notification init
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/app_icon');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettingsMacOS = MacOSInitializationSettings();
  final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

  // init timezones properly
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));

  runApp(PizzaPlanner());

  //await Hive.close();
}

class PizzaPlanner extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PizzaPlanner",
      home: PizzaEventsPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case "/": {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
      case "/event/pick_recipe": {
        return MaterialPageRoute(builder: (context) => PickPizzaRecipePage());
      }
      case "/event/add": {
        return MaterialPageRoute(builder: (context) => AddPizzaEventPage(settings.arguments as PizzaRecipe));
      }
      case "/event/view": {
        return MaterialPageRoute(builder: (context) => PizzaEventPage(settings.arguments as PizzaEvent));
      }

      default: {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
    }
  }
}

Future selectNotification(String? payload) async {
  if (payload == null) {
    print("Payload: null");
    return;
  }
  print("Payload: $payload");
}