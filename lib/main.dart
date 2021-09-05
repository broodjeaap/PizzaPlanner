import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/pages/add_pizza_event_page.dart';
import 'package:pizzaplanner/pages/add_recipe_page.dart';
import 'package:pizzaplanner/pages/edit_recipe_step_page.dart';
import 'package:pizzaplanner/pages/edit_recipe_sub_step_page.dart';
import 'package:pizzaplanner/pages/pick_pizza_recipe_page.dart';
import 'package:pizzaplanner/pages/pizza_event_notification_page.dart';
import 'package:pizzaplanner/pages/pizza_event_page.dart';
import 'package:pizzaplanner/pages/pizza_events_page.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/pages/recipe_page.dart';
import 'package:pizzaplanner/pages/recipe_step_instruction_page.dart';
import 'package:pizzaplanner/pages/recipes_page.dart';
import 'package:pizzaplanner/recipes/neapolitan_cold.dart';
import 'package:pizzaplanner/util.dart';
import 'package:rxdart/subjects.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();
String? selectedNotificationPayload;


Future<void> main() async {
  // hive init
  await Hive.initFlutter();

  Hive.registerAdapter(PizzaEventAdapter());
  Hive.registerAdapter(PizzaRecipeAdapter());
  Hive.registerAdapter(RecipeStepAdapter());
  Hive.registerAdapter(RecipeSubStepAdapter());
  Hive.registerAdapter(IngredientAdapter());

  await Hive.openBox<PizzaEvent>("PizzaEvents");
  final pizzaRecipesBox = await Hive.openBox<PizzaRecipe>("PizzaRecipes");

  if (pizzaRecipesBox.isEmpty){
    pizzaRecipesBox.addAll(await getRecipes());
  }

  // notification init
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/app_icon');
  const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettingsMacOS = MacOSInitializationSettings();
  const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
  });

  // init timezones properly
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = "/";
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails!.payload;
    initialRoute = "/event/notification";
  }

  runApp(PizzaPlanner(initialRoute));

  //await Hive.close();
}

class PizzaPlanner extends StatefulWidget {
  final String initialRoute;

  const PizzaPlanner(this.initialRoute);

  @override
  PizzaPlannerState createState() => PizzaPlannerState();
}

class PizzaPlannerState extends State<PizzaPlanner> {
  // need this because in _configureSelectNotificationSubject() we need to pushNamed a route
  // but only descendants of a MaterialApp have access to the Navigator,
  // and this build() returns the MaterialApp
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState(){
    super.initState();
    _configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PizzaPlanner",
      initialRoute: widget.initialRoute,
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await navigatorKey.currentState?.pushNamed('/event/notification', arguments: payload);
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
        final pizzaRecipe = settings.arguments as PizzaRecipe?;
        if (pizzaRecipe == null){
          break;
        }
        return MaterialPageRoute(builder: (context) => AddPizzaEventPage(pizzaRecipe));
      }
      case "/event/view": {
        final pizzaEvent = settings.arguments as PizzaEvent?;
        if (pizzaEvent == null){
          break;
        }
        return MaterialPageRoute(builder: (context) => PizzaEventPage(pizzaEvent));
      }
      case "/recipe/view": {
        final pizzaRecipe = settings.arguments as PizzaRecipe?;
        if (pizzaRecipe == null){
          break;
        }
        return MaterialPageRoute(builder: (context) => RecipePage(pizzaRecipe));
      }
      case "/event/notification": {
        if (selectedNotificationPayload != null) {
          return MaterialPageRoute(builder: (context) => PizzaEventNotificationPage(selectedNotificationPayload));
        } else if (settings.arguments != null) {
          
          return MaterialPageRoute(builder: (context) => PizzaEventNotificationPage(settings.arguments as String?));
        } else {
          return MaterialPageRoute(builder: (context) => PizzaEventsPage());
        }
      }
      case "/event/recipe_step": {
        final recipeStepInstructionArgument = settings.arguments as RecipeStepInstructionPageArguments?;
        if (recipeStepInstructionArgument == null){
          break;
        }
        return MaterialPageRoute(builder: (context) => RecipeStepInstructionPage(recipeStepInstructionArgument));
      }
      case "/recipes/view": {
        return MaterialPageRoute(builder: (context) => RecipesPage());
      }
      case "/recipes/add": {
        return MaterialPageRoute(builder: (context) => AddRecipePage());
      }
      case "/recipes/add/edit_step": {
        final recipeStep = settings.arguments as RecipeStep?;
        if(recipeStep == null){
          break;
        }
        return MaterialPageRoute(builder: (context) => EditRecipeStepPage(recipeStep));
      }
      case "/recipes/add/edit_sub_step": {
        final subStep = settings.arguments as RecipeSubStep?;
        if(subStep == null){
          break;
        }
        return MaterialPageRoute(builder: (context) => EditRecipeSubStepPage(subStep));
      }
      default: {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
    }
    return MaterialPageRoute(builder: (context) => PizzaEventsPage());
  }
}

