import 'package:flutter/material.dart';
import 'package:pizzaplanner/pages/AddPizzaEvent/AddPizzaEventPage.dart';
import 'package:pizzaplanner/pages/PizzaEventsPage.dart';

void main() {
  runApp(PizzaPlanner());
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
      case "/add": {
        return MaterialPageRoute(builder: (context) => AddPizzaEventPage());
      }

      default: {
        return MaterialPageRoute(builder: (context) => PizzaEventsPage());
      }
    }
  }
}