import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/pages/pizza_events_page.dart';
import 'package:pizzaplanner/pages/recipes_page.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              "Pizza Planner",
              style: TextStyle(color: Colors.black, fontSize: 30)
            ),
            /*decoration: BoxDecoration(
              color: Colors.redAccent,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage()
              )
            ),*/
          ),
          ListTile(
            leading: const Icon(FontAwesome5.calendar_alt),
            title: const Text("Events"),
            onTap: () => {
              Navigator.pushNamed(context, PizzaEventsPage.route)
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5.pizza_slice),
            title: const Text("Recipes"),
            onTap: () => {
              Navigator.pushNamed(context, RecipesPage.route)
            },
          ),
        ]
      )
    );
  }
}