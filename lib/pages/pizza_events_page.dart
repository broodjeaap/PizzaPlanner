import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/pages/pick_pizza_recipe_page.dart';
import 'package:pizzaplanner/pages/pizza_event_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/widgets/pizza_event_widget.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PizzaEventsPage extends StatefulWidget {
  static const String route = "/";
  
  @override
  PizzaEventsState createState() => PizzaEventsState();
}

class PizzaEventsState extends State<PizzaEventsPage> {
  List<PizzaEvent> pizzaEvents = <PizzaEvent>[
  ];

  @override
  Widget build(BuildContext context) {
    return PizzaPlannerScaffold(
      title: const Text("Pizza Events"),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<PizzaEvent>(PizzaEvent.hiveName).listenable(),
          builder: (context, Box<PizzaEvent> pizzaEventBox, widget) {
            if (pizzaEventBox.isEmpty){
              return Container();
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: pizzaEventBox.length,
              itemBuilder: (BuildContext context, int i) {
                final pizzaEvent = pizzaEventBox.get(i);
                if (pizzaEvent == null || pizzaEvent.archived || pizzaEvent.deleted){
                  return const SizedBox();
                }
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PizzaEventPage.route, arguments: pizzaEvent);
                  },
                  onLongPress: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(pizzaEvent.name),
                          content: const Text("What do you want to do?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, PizzaEventPage.route, arguments: pizzaEvent);
                              },
                              child: const Text("View"),
                            ),
                            if (pizzaEvent.dateTime.isBefore(DateTime.now())) TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                pizzaEvent.archived = true;
                                pizzaEvent.save();
                              },
                              child: const Text("Archive"),
                            ) else const SizedBox(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(context: context, builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text("Delete?"),
                                      content: const Text("Are you sure?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Back"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (pizzaEvent.isInBox){
                                              pizzaEvent.cancelNotifications();
                                              pizzaEvent.deleted = true;
                                              pizzaEvent.save();
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                                        ),
                                      ]
                                  );
                                });
                              },
                              child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                            ),
                          ]
                      );
                    });
                  },
                  child: PizzaEventWidget(pizzaEvent),
                );
              },
              separatorBuilder: (BuildContext context, int i) {
                final pizzaEvent = pizzaEventBox.get(i);
                if (pizzaEvent == null || pizzaEvent.archived || pizzaEvent.deleted){
                  return const SizedBox();
                }
                return const Divider();
              },
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final dynamic newPizzaEvent = await Navigator.pushNamed(
              context,
              PickPizzaRecipePage.route,
            );

            if (newPizzaEvent != null){
              addPizzaEvent(newPizzaEvent as PizzaEvent);
            }
          },
          tooltip: "Add Pizza Plans",
          backgroundColor: Theme.of(context).buttonColor,
          child: Center(
              child: Row(
                  children: const <Widget>[
                    Icon(Icons.add),
                    Icon(Icons.local_pizza_rounded),
                  ]
              )
          )
      ),
    );
  }

  void addPizzaEvent(PizzaEvent pizzaEvent){
    setState(() {
      pizzaEvents.add(
          pizzaEvent
      );
    });
  }
}