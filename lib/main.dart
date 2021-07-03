import 'package:flutter/material.dart';
import 'package:pizzaplanner/pages/AddPlannedPizzaPage.dart';
import 'package:pizzaplanner/pages/PlannedPizzasPage.dart';

void main() {
  runApp(PizzaPlanner());
}

class PizzaPlanner extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PizzaPlanner",
      home: PlannedPizzasPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case "/": {
        return MaterialPageRoute(builder: (context) => PlannedPizzasPage());
      }
      case "/add": {
        return MaterialPageRoute(builder: (context) => AddPlannedPizzaPage());
      }

      default: {
        return MaterialPageRoute(builder: (context) => PlannedPizzasPage());
      }
    }
  }
}