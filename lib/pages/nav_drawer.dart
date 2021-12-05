import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/pages/archived_pizza_event_page.dart';
import 'package:pizzaplanner/pages/pizza_events_page.dart';
import 'package:pizzaplanner/pages/privacy_policy_page.dart';
import 'package:pizzaplanner/pages/recipes_page.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final modalRoute = ModalRoute.of(context);
    final currentRouteName = modalRoute?.settings.name ?? "";
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Pizza Planner",
              style: Theme.of(context).textTheme.headline3
            )),
          ListTile(
            leading: const Icon(FontAwesome5.calendar_alt),
            title: const Text("Events"),
            onTap: () {
              Navigator.pop(context);
              if (currentRouteName == PizzaEventsPage.route){
                return;
              }
              Navigator.pushNamed(context, PizzaEventsPage.route);
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5.pizza_slice),
            title: const Text("Recipes"),
            onTap: () {
              Navigator.pop(context);
              if (currentRouteName == RecipesPage.route){
                return;
              }
              Navigator.pushNamed(context, RecipesPage.route);
            },
          ),
          ListTile(
            leading: const Icon(FontAwesome5.archive),
            title: const Text("Archive"),
            onTap: () {
              Navigator.pop(context);
              if (currentRouteName == ArchivedPizzaEventsPage.route){
                return;
              }
              Navigator.pushNamed(context, ArchivedPizzaEventsPage.route);
            },
          ),
          Expanded(child: Container()),
          ListTile(
            leading: const Icon(FontAwesome5.file_contract),
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.pop(context);
              if (currentRouteName == ArchivedPizzaEventsPage.route){
                return;
              }
              Navigator.pushNamed(context, PrivacyPolicyPage.route);
            },
          ),
        ]
      )
    );
  }
}