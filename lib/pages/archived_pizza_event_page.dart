import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/pages/pizza_event_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/widgets/pizza_event_widget.dart';

class ArchivedPizzaEventsPage extends StatefulWidget {
  static const String route = "/events/archived";
  
  @override
  ArchivedPizzaEventsPageState createState() => ArchivedPizzaEventsPageState();
}

class ArchivedPizzaEventsPageState extends State<ArchivedPizzaEventsPage> {
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
      title: const Text("Archived Pizza Events"),
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
                if (pizzaEvent == null || !pizzaEvent.archived || pizzaEvent.deleted){
                  return const SizedBox();
                }
                return InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text(pizzaEvent.name),
                          content: const Text("Remove from archive?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                pizzaEvent.archived = false;
                                await pizzaEvent.save();
                              },
                              child: const Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            )
                          ]
                      );
                    });
                  },
                  child: PizzaEventWidget(pizzaEvent),
                );
              },
              separatorBuilder: (BuildContext context, int i) {
                final pizzaEvent = pizzaEventBox.get(i);
                if (pizzaEvent == null || !pizzaEvent.archived || pizzaEvent.deleted){
                  return const SizedBox();
                }
                return const Divider();
              },
            );
          }
      ),
    );
  }
}