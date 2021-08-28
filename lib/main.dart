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
import 'package:pizzaplanner/pages/PizzaEventNotificationPage.dart';
import 'package:pizzaplanner/pages/PizzaEventPage.dart';
import 'package:pizzaplanner/pages/PizzaEventsPage.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/pages/PizzaRecipePage.dart';
import 'package:pizzaplanner/pages/RecipeStepInstructionPage.dart';
import 'package:pizzaplanner/recipes/NeapolitanCold.dart';
import 'package:pizzaplanner/util.dart';
import 'package:rxdart/subjects.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();
String? selectedNotificationPayload;


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
    pizzaRecipesBox.addAll([
      getNeapolitanCold()
    ]);
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
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      selectedNotificationPayload = payload;
      print("onSelectNotification");
      selectNotificationSubject.add(payload);
  });

  // init timezones properly
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = "/";
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.payload;
    print("Started by notification");
    initialRoute = "/event/notification";
  }

  runApp(PizzaPlanner(initialRoute));

  //await Hive.close();
}

class PizzaPlanner extends StatefulWidget {
  final String initialRoute;

  PizzaPlanner(this.initialRoute);

  @override
  PizzaPlannerState createState() => PizzaPlannerState();
}

class PizzaPlannerState extends State<PizzaPlanner> {
  // need this because in _configureSelectNotificationSubject() we need to pushNamed a route
  // but only descendants of a MaterialApp have access to the Navigator,
  // and this build() returns the MaterialApp
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState(){
    super.initState();
    this._configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PizzaPlanner",
      initialRoute: this.widget.initialRoute,
      navigatorKey: this.navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      print("tapped on notification");
      await this.navigatorKey.currentState?.pushNamed('/event/notification', arguments: payload);
    });
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
      case "/event/recipe": {
        return MaterialPageRoute(builder: (context) => PizzaRecipePage(settings.arguments as PizzaEvent));
      }
      case "/event/notification": {
        if (selectedNotificationPayload != null) {
          return MaterialPageRoute(builder: (context) => PizzaEventNotificationPage(selectedNotificationPayload!));
        } else if (settings.arguments != null) {
          return MaterialPageRoute(builder: (context) => PizzaEventNotificationPage(settings.arguments as String));
        } else {
          return MaterialPageRoute(builder: (context) => PizzaEventsPage());
        }
      }
      case "/event/recipe_step": {
        return MaterialPageRoute(builder: (context) => RecipeStepInstructionPage(settings.arguments as RecipeStepInstructionPageArguments));
      }
      default: {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
    }
  }
}

