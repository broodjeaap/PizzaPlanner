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
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      selectedNotificationPayload = payload;
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
    initialRoute = "/event/notification";
  }

  runApp(
    MaterialApp(
      title: "PizzaPlanner",
      initialRoute: initialRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    )
  );

  //await Hive.close();
}

class PizzaPlanner extends StatefulWidget {
  @override
  PizzaPlannerState createState() => PizzaPlannerState();
}

class PizzaPlannerState extends State<PizzaPlanner> {

  @override
  void initState(){
    super.initState();
    this._configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    return PizzaEventsPage();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, '/event/notification', arguments: payload);
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
      case "/event/notification": {
        var argument = settings.arguments as String;
        if (selectedNotificationPayload != null) {
          argument = selectedNotificationPayload!;
        }
        return MaterialPageRoute(builder: (context) => PizzaEventNotificationPage(argument));
      }

      default: {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
    }
  }
}

